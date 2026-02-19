{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment = {
    systemPackages = with pkgs.gnomeExtensions; [
      control-monitor-brightness-and-volume-with-ddcutil
    ];
  };
}
