{
  description = "Unified Multi-Host NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

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
    ...
  } @ inputs: let
    specialArgs = {
      inherit (inputs);
      inherit (nixpkgs) lib;
    };

    pkgs-x86 = import nixpkgs {system = "x86_64-linux";};

    sharedModules = [
      ./common
      nix-flatpak.nixosModules.nix-flatpak
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.jax.imports = [./common/modules/home];
        };
      }
    ];
  in {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules =
          sharedModules ++ [./desktop];
      };

      dalaptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules =
          sharedModules ++ [./laptop];
      };

      pipa = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit (nixpkgs) lib;};
        modules =
          sharedModules ++ [./tablet];
      };

      pipa-cross = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit (nixpkgs) lib;};
        modules =
          sharedModules ++ [./tablet];
      };
    };

    apps."x86_64-linux".default = {
      type = "app";
      program = "${
        pkgs-x86.callPackage ./tablet/pkgs/build-images.nix {
          pkgs = pkgs-x86;
          toplevel = self.nixosConfigurations.pipa-cross.config.system.build.toplevel;
        }
      }/bin/build-pipa-images";
    };
  };
}
