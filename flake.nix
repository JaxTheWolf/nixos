{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    czkawka-master.url = "path:./common/flakes/czkawka-master";
    fet.url = "path:./common/flakes/fet";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      home-manager,
      ...
    }@inputs:
    let
      specialArgs = { inherit (inputs) czkawka-master fet; };
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

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.jax = {
                  imports = [
                    ./common/modules/home
                    ./desktop/modules/home
                  ];
                };
              };
            }
          ];
        };

        dalaptop = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./common
            ./laptop
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.jax = {
                  imports = [
                    ./common/modules/home
                    ./laptop/modules/home
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
