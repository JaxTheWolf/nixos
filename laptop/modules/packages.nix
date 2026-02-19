{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    btop
    nvtopPackages.intel
    intel-gpu-tools
  ];
}
