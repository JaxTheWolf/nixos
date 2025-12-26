{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    czkawka-master.url = "path:./flakes/czkawka-master";
    solaar-master.url = "path:./flakes/solaar-master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      czkawka-master,
      solaar-master,
      ...
    }:
    {
      nixosConfigurations = {
        epiquev2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit czkawka-master;
            inherit solaar-master;
          };
          modules = [
            ./configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}
