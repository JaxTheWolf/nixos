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
        modules = [./epiquev2];
      };

      dalaptop = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./dalaptop];
      };

      pipa = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [./pipa];
      };
    };

    homeConfigurations = {
      "jax@epiquev2" = mkHome {hostName = "epiquev2";};
      "jax@dalaptop" = mkHome {hostName = "dalaptop";};
      "jax@pipa" = mkHome {hostName = "pipa";};
      "jax@lenovo-server" = mkHome {hostName = "lenovo-server";};
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
