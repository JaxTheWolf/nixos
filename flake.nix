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
      inherit (inputs);
      inherit (nixpkgs) lib;
    };

    pkgs-x86 = import nixpkgs {system = "x86_64-linux";};

    sharedModules = [
      ./common
      nix-flatpak.nixosModules.nix-flatpak
      home-manager.nixosModules.home-manager

      {
        nixpkgs.overlays = [filefinder.overlays.default];
        nixpkgs.config.allowUnfree = true;
      }

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.jax.imports = [./common/modules/home filefinder.homeManagerModules.default];
        };
      }
    ];

    tabletSharedModules =
      [
        ./tablet

        ({...}: {
          boot.kernelPackages = let
            crossPkgs = import nixpkgs {
              localSystem = "x86_64-linux";
              crossSystem = "aarch64-linux";
              config.allowUnfree = true;
            };
          in
            crossPkgs.linuxPackagesFor (crossPkgs.callPackage ./tablet/pkgs/kernel.nix {});
        })
      ]
      ++ sharedModules;
  in {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          sharedModules
          ++ [
            ./desktop
            {nixpkgs.hostPlatform = "x86_64-linux";}
          ];
      };

      dalaptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          sharedModules
          ++ [
            ./laptop
            {nixpkgs.hostPlatform = "x86_64-linux";}
          ];
      };

      pipa = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          tabletSharedModules
          ++ [
            {nixpkgs.hostPlatform = "aarch64-linux";}
          ];
      };
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
