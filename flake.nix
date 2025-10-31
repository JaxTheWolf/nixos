{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Keeping this for the binary cache!
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = { self, nixpkgs, nix-flatpak, chaotic, ... }: {
    nixosConfigurations = {
      epiquev2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          
          # This module adds the Chaotic overlay AND the necessary binary cache.
          chaotic.nixosModules.default
        ];
      };
    };
  };
}