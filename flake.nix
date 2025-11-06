{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-flatpak, chaotic, ... }: {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          chaotic.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };
    };
  };
}