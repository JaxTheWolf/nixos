{
  description = "Unified Multi-Host NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    filefinder.url = "git+ssh://git@gt.awroo.fun/esavojt/filefinder.git";
    filefinder.inputs.nixpkgs.follows = "nixpkgs";

    # stylix.url = "github:nix-community/stylix";
    stylix.url = "github:nix-community/stylix/pull/2406/merge";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...} @ inputs: let
    libs = import ./libs {inherit inputs self;};
    inherit (libs) mkHome mkNixos;
  in {
    devShells = inputs.nixpkgs.lib.genAttrs inputs.nixpkgs.lib.systems.flakeExposed (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          deadnix
          statix
        ];
      };
    });
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      epiquev2 = mkNixos {name = "epiquev2";};
      dalaptop = mkNixos {name = "dalaptop";};
      pipa = mkNixos {
        name = "pipa";
        system = "aarch64-linux";
      };
    };

    homeConfigurations = {
      "jax@epiquev2" = mkHome {name = "jax@epiquev2";};
      "jax@dalaptop" = mkHome {name = "jax@dalaptop";};
      "jax@pipa" = mkHome {name = "jax@pipa";};
      "jax@lenovo-server" = mkHome {name = "jax@lenovo-server";};
      "ubuntu@oracle-server" = mkHome {
        name = "ubuntu@oracle-server";
        system = "aarch64-linux";
      };
    };
  };
}
