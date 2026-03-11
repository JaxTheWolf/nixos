{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
    ../common
  ];

  networking = {
    hostName = "dalaptop";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    bluetooth = {
      settings = {
        General = {
          Name = "dalaptop";
        };
      };
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [

        vaapi-intel-hybrid
        vpl-gpu-rt
      ];
    };
  };
}
