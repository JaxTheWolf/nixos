{
  description = "Unified Multi-Host NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    filefinder.url = "git+ssh://git@gt.awroo.fun/esavojt/filefinder.git";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-flatpak,
    home-manager,
    filefinder,
    ...
  } @ inputs: let
    specialArgs = {
      inherit inputs;
    };

    pkgs-x86 = import nixpkgs {system = "x86_64-linux";};

    libs = import ./libs {inherit inputs self;};
    mkHome = libs.mkHome;
  in {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./desktop];
      };

      dalaptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./laptop];
      };

      pipa = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./tablet];
      };
    };

    homeConfigurations = {
      "jax@epiquev2" = mkHome "epiquev2" [./desktop/modules/home];
      "jax@dalaptop" = mkHome "dalaptop" [./laptop/modules/home];
      "jax@pipa" = mkHome "pipa" [./tablet/modules/home];
    };

    apps."x86_64-linux".default = {
      type = "app";
      program = "${
        pkgs-x86.callPackage ./tablet/pkgs/build-images.nix {
          pkgs = pkgs-x86;
          toplevel = self.nixosConfigurations.pipa.config.system.build.toplevel;
        }
      }/bin/build-pipa-images";
    };
  };
}
