{
  description = "Czkawka (Master) - Built with Naersk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    czkawka-src = {
      url = "github:qarmin/czkawka/9.0.0";
      flake = false;
    };

    # Naersk: Builds Rust crates without needing a manual cargoHash
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
        wrapGAppsHook4
        gobject-introspection
        cargo
        rustc
      ];

      buildInputs = with pkgs; [
        glib
        gtk4
        cairo
        pango
        gdk-pixbuf
        atk
        libadwaita
      ];

    in
    {
      packages.${system}.default = naersk-lib.buildPackage {
        pname = "czkawka";
        version = "master";
        src = czkawka-src;

        inherit nativeBuildInputs buildInputs;

        RUSTFLAGS = "-C target-cpu=native";
        NIX_CFLAGS_COMPILE = "-march=native -mtune=native";

        postInstall = ''
          install -Dm444 -t $out/share/applications data/com.github.qarmin.czkawka.desktop
          install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka.svg
          install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka-symbolic.svg
          install -Dm444 -t $out/share/metainfo data/com.github.qarmin.czkawka.metainfo.xml
        '';
      };
    };
}
