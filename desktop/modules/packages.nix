{
  config,
  pkgs,
  lib,
  czkawka-master,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    amdgpu_top
    arch-install-scripts
    ccache
    czkawka-master.packages.${pkgs.stdenv.hostPlatform.system}.default
    fahclient
    lact
    nvtopPackages.amd
    openrgb-with-all-plugins
    radeontop
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    swtpm
    zenmonitor
  ];
}
