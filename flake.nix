{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    czkawka-master.url = "path:/etc/nixos/flakes/czkawka-master";
  };

  outputs = { self, nixpkgs, nix-flatpak, czkawka-master, ... }: {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit czkawka-master; };
        modules = [
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}