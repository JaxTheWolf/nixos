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

    sharedModules = [
      ./common
      nix-flatpak.nixosModules.nix-flatpak

      {
        nixpkgs.overlays = [filefinder.overlays.default];
        nixpkgs.config.allowUnfree = true;
      }

      {
        virtualisation.vmVariant = {
          imports = [home-manager.nixosModules.home-manager];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            users.jax = {
              imports = sharedHomeModules;
            };
          };
        };
      }
    ];

    tabletSharedModules =
      [
        ./tablet

        (_: {
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

    sharedHomeModules = [
      ./common/modules/home
      filefinder.homeManagerModules.default
      {
        home.username = "jax";
        home.homeDirectory = "/home/jax";
      }
    ];

    mkHome = hostName: extraModules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = self.nixosConfigurations.${hostName}.pkgs;

        extraSpecialArgs =
          specialArgs
          // {
            osConfig = self.nixosConfigurations.${hostName}.config;
          };

        modules = sharedHomeModules ++ extraModules;
      };
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
