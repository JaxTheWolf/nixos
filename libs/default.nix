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
    hostName,
    system ? "x86_64-linux",
    extraModules ? [],
  }: let
    hasNixosConfig = self.nixosConfigurations ? ${hostName};
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
        ]
        ++ lib.optionals (!lib.strings.hasInfix "server" hostName) [../common/modules/home/gui]
        ++ extraModules;
    };
}
