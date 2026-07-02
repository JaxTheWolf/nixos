{
  inputs,
  self,
}: let
  specialArgs = {
    inherit inputs;
  };
  lib = inputs.nixpkgs.lib;
in {
  mkHome = {
    name,
    system ? "x86_64-linux",
    extraModules ? [],
  }: let
    stringParts = inputs.nixpkgs.lib.strings.splitString "@" name;

    fallbackUser = builtins.elemAt stringParts 0;
    hostName = builtins.elemAt stringParts 1;

    hasNixosConfig = self.nixosConfigurations ? ${hostName};

    username =
      if hasNixosConfig && (builtins.hasAttr fallbackUser self.nixosConfigurations.${hostName}.config.users.users)
      then fallbackUser
      else fallbackUser;

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
          ../common/modules/home
          ../${hostName}/modules/home

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
        ++ lib.optionals (!lib.strings.hasInfix "server" hostName) [../common/modules/home/gui]
        ++ extraModules;
    };
}
