{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    btop
    gnome-power-manager
    intel-gpu-tools
    nvtopPackages.intel
  ];
}
