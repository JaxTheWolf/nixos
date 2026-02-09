{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    czkawka-master.url = "path:./flakes/czkawka-master";
    # czkawka-git.url = "github:qarmin/czkawka?dir=misc/nix";
    solaar-master.url = "path:./flakes/solaar-master";
    fet.url = "path:./flakes/fet";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      czkawka-master,
      solaar-master,
      fet,
      ...
    }:
    {
      nixosConfigurations = {
        epiquev2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit czkawka-master;
            inherit solaar-master;
            inherit fet;
          };
          modules = [
            ./configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}
