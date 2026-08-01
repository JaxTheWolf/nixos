{
  inputs,
  self,
}: let
  lib = inputs.nixpkgs.lib;

  specialArgs = {
    inherit inputs self;
  };
in {
  mkNixos = {
    name,
    username ? "jax",
    system ? "x86_64-linux",
    extraModules ? [],
  }:
    lib.nixosSystem {
      inherit specialArgs;
      modules =
        [
          ../hosts/${name}
          {nixpkgs.hostPlatform = lib.mkDefault system;}
        ]
        ++ extraModules;
    };

  mkHome = {
    name,
    system ? "x86_64-linux",
    extraModules ? [],
  }: let
    stringParts = lib.strings.splitString "@" name;
    username = builtins.elemAt stringParts 0;
    hostName = builtins.elemAt stringParts 1;

    hasNixosConfig = self.nixosConfigurations ? ${hostName};

    pkgs =
      if hasNixosConfig
      then self.nixosConfigurations.${hostName}.pkgs
      else
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.filefinder.overlays.default
            self.overlays.nautilus
          ];
        };

    osConfig =
      if hasNixosConfig
      then self.nixosConfigurations.${hostName}.config
      else {
        networking.hostName = hostName;
        nixpkgs.hostPlatform = system;
        myConfig = {
          role = "server";
          desktop.enable = false;
          desktop.gnome.enable = false;
          desktop.flatpak.enable = false;
        };
      };

    hostHomeFile = ../hosts/${hostName}/home.nix;
    hasHostHomeFile = builtins.pathExists hostHomeFile;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs =
        specialArgs
        // {
          inherit osConfig;
        };

      modules =
        [
          ../hosts/common/modules/home
        ]
        ++ lib.optionals (osConfig.myConfig.desktop.enable or (!lib.strings.hasInfix "server" hostName)) [
          ../hosts/common/modules/home/gui
        ]
        ++ lib.optionals hasHostHomeFile [
          hostHomeFile
        ]
        ++ [
          {
            home = {
              inherit username;
              homeDirectory =
                if username == "root"
                then "/root"
                else "/home/${username}";
            };
          }
        ]
        ++ extraModules;
    };
}
