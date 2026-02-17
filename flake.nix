{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    czkawka-master.url = "path:./common/flakes/czkawka-master";
    solaar-master.url = "path:./common/flakes/solaar-master";
    fet.url = "path:./common/flakes/fet";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      ...
    }@inputs:
    let
      specialArgs = { inherit (inputs) czkawka-master solaar-master fet; };
    in
    {
      nixosConfigurations = {
        epiquev2 = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./common
            ./desktop
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./common
            ./laptop
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };
      };
    };
}
