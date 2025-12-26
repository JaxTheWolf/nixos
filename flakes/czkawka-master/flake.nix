{
  description = "Czkawka (Master) - Built with Naersk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # The source code from GitHub
    czkawka-src = {
      url = "github:qarmin/czkawka";
      flake = false; # The upstream repo doesn't have a flake.nix
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

      # Czkawka requires these system libraries
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
        # Optional: libadwaita if the master branch has switched to it
      ];

    in
    {
      packages.${system}.default = naersk-lib.buildPackage {
        pname = "czkawka";
        version = "master";
        src = czkawka-src;

        # Add the dependencies
        inherit nativeBuildInputs buildInputs;

        # We need to manually install the desktop files/icons because Naersk
        # only installs the binaries by default.
        postInstall = ''
          install -Dm444 -t $out/share/applications data/com.github.qarmin.czkawka.desktop
          install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka.svg
          install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka-symbolic.svg
          install -Dm444 -t $out/share/metainfo data/com.github.qarmin.czkawka.metainfo.xml
        '';
      };

      # For 'nix develop' - gives you a shell with cargo/rustc ready
      devShells.${system}.default = pkgs.mkShell {
        inherit nativeBuildInputs buildInputs;
      };
    };
}
