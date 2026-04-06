{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    amdgpu_top
    arch-install-scripts
    ccache
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
