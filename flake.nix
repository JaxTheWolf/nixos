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
    specialArgs = {inherit (inputs);};

    pkgs-x86 = import nixpkgs {system = "x86_64-linux";};

    sharedTabletModules = [
      ./tablet
      ./common
      nix-flatpak.nixosModules.nix-flatpak
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.jax.imports = [
            ./common/modules/home
            ./tablet/modules/home
          ];
        };
      }
    ];
  in {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./common
          ./desktop
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jax.imports = [
                ./common/modules/home
                ./desktop/modules/home
              ];
            };
          }
        ];
      };

      dalaptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        system = "x86_64-linux";
        modules = [
          ./common
          ./laptop
          nix-flatpak.nixosModules.nix-flatpak
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jax.imports = [
                ./common/modules/home
                ./laptop/modules/home
              ];
            };
          }
        ];
      };

      pipa = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit (nixpkgs) lib;};
        modules =
          sharedTabletModules
          ++ [
            {
              nixpkgs.config.allowUnfree = true;
              boot.kernelPackages = let
                pkgs-native = import nixpkgs {
                  system = "aarch64-linux";
                  config.allowUnfree = true;
                };
              in
                pkgs-native.linuxPackagesFor (pkgs-native.callPackage ./tablet/pkgs/kernel.nix {});
            }
          ];
      };

      pipa-cross = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit (nixpkgs) lib;};
        modules =
          sharedTabletModules
          ++ [
            {
              nixpkgs.config.allowUnfree = true;
              boot.kernelPackages = let
                pkgs-cross = import nixpkgs {
                  localSystem = "x86_64-linux";
                  crossSystem = "aarch64-linux";
                  config.allowUnfree = true;
                };
              in
                pkgs-cross.linuxPackagesFor (pkgs-cross.callPackage ./tablet/pkgs/kernel.nix {});
            }
          ];
      };
    };

    apps."x86_64-linux".default = {
      type = "app";
      program = "${pkgs-x86.callPackage ./tablet/pkgs/build-images.nix {
        pkgs = pkgs-x86;
        toplevel = self.nixosConfigurations.pipa-cross.config.system.build.toplevel;
      }}/bin/build-pipa-images";
    };
  };
}
