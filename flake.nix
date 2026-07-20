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
  } @ inputs: let
    libs = import ./libs {inherit inputs self;};
    mkHome = libs.mkHome;
    mkNixos = libs.mkNixos;
  in {
    nixosConfigurations = {
      epiquev2 = mkNixos {name = "epiquev2";};
      dalaptop = mkNixos {name = "dalaptop";};
      pipa = mkNixos {name = "pipa";};
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
