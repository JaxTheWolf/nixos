{
  config,
  pkgs,
  lib,
  czkawka-master,
  solaar-master,
  fet,
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

  fonts = {
    packages = with pkgs; [
      fira-code
      font-awesome
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.symbols-only
      nerd-fonts.ubuntu-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      ubuntu-classic
    ];
  };
}
