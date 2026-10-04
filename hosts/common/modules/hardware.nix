{
  pkgs,
  lib,
  config,
  ...
}: {
  hardware = {
    enableRedistributableFirmware = true;

    bluetooth = lib.mkIf config.myConfig.hardware.bluetooth.enable {
      enable = true;
      package = pkgs.bluez.overrideAttrs (old: {
        configureFlags =
          old.configureFlags
          ++ [
            "--enable-sixaxis"
          ];
      });

      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
      settings = {
        General = {
          Experimental = true;
          Name = config.networking.hostName;
        };
      };
    };

    i2c.enable = true;

    graphics = {
      enable = true;
      package = pkgs.mesa;
    };
  };
}
