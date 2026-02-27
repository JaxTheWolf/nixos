{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    btop
    gnome-power-manager 
    nvtopPackages.intel
    intel-gpu-tools
  ];
}
