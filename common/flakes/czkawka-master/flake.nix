{
  description = "Krokiet (Czkawka Slint GUI)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    czkawka-src = {
      url = "github:qarmin/czkawka";
      flake = false;
    };
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      czkawka-src,
      naersk,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      naersk-lib = pkgs.callPackage naersk { };

      nativeBuildInputs = with pkgs; [
        pkg-config
        cmake
        makeWrapper
        cargo
        rustc
      ];

      runtimeLibs = with pkgs; [
        wayland
        libxkbcommon
        libglvnd
        fontconfig
        libX11
        libXcursor
        libXi
        libXrandr
      ];

    in
    {
      packages.${system}.default = naersk-lib.buildPackage {
        pname = "krokiet";
        version = "master";
        src = czkawka-src;

        nativeBuildInputs = nativeBuildInputs;
        buildInputs = runtimeLibs;

        cargoBuildOptions =
          x:
          x
          ++ [
            "-p"
            "krokiet"
          ];

        buildAndCheckFeatures = [
          "winit_wayland"
          "winit_x11"
        ];

        RUSTFLAGS = "-C target-cpu=native";
        NIX_CFLAGS_COMPILE = "-march=native -mtune=native";

        postInstall = ''
          wrapProgram $out/bin/krokiet \
            --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath runtimeLibs}

          install -Dm444 -t $out/share/applications data/io.github.qarmin.krokiet.desktop

          install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/io.github.qarmin.krokiet.svg \

          install -Dm444 -t $out/share/metainfo data/io.github.qarmin.krokiet.metainfo.xml
        '';
      };
    };
}
