{
  inputs,
  self,
}: let
  specialArgs = {
    inherit inputs;
  };
in {
  mkHome = hostName: extraModules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = self.nixosConfigurations.${hostName}.pkgs;

      extraSpecialArgs =
        specialArgs
        // {
          osConfig = self.nixosConfigurations.${hostName}.config;
        };

      modules = [../common/modules/home] ++ extraModules;
    };
}
