{
  inputs,
  self,
}: let
  specialArgs = {
    inherit inputs self;
  };
  lib = inputs.nixpkgs.lib;
in {
  mkNixos = {
    name,
    extraModules ? [],
  }:
    lib.nixosSystem {
      inherit specialArgs;
      modules =
        [
          ../hosts/${name}
        ]
        ++ extraModules;
    };

  mkHome = {
    name,
    system ? "x86_64-linux",
    extraModules ? [],
  }: let
    stringParts = inputs.nixpkgs.lib.strings.splitString "@" name;

    fallbackUser = builtins.elemAt stringParts 0;
    hostName = builtins.elemAt stringParts 1;

    hasNixosConfig = self.nixosConfigurations ? ${hostName};

    username = fallbackUser;

    pkgs =
      if hasNixosConfig
      then self.nixosConfigurations.${hostName}.pkgs
      else
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [inputs.filefinder.overlays.default];
        };

    osConfig =
      if hasNixosConfig
      then self.nixosConfigurations.${hostName}.config
      else {
        networking.hostName = hostName;
        nixpkgs.hostPlatform = system;
      };
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
          ../hosts/${hostName}/modules/home

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
        ++ lib.optionals (!lib.strings.hasInfix "server" hostName) [../hosts/common/modules/home/gui]
        ++ extraModules;
    };
}
