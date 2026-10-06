{
  lib,
  config,
  pkgs,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
  isDesktop = config.myConfig.desktop.enable or false;
  dockerEnabled = config.myConfig.virtualisation.docker.enable or false;
  libvirtdEnabled = config.myConfig.virtualisation.libvirtd.enable or false;
in {
  virtualisation = {
    docker = lib.mkIf dockerEnabled {
      enable = true;
      autoPrune.enable = false;
      storageDriver = "btrfs";
      enableOnBoot = true;
    };

    libvirtd = lib.mkIf (isx86 && libvirtdEnabled) {
      enable = true;
      extraConfig = ''
        unix_sock_group = "qemu-libvirtd"
      '';
      onBoot = "ignore";
    };

    spiceUSBRedirection.enable = isx86 && libvirtdEnabled;
  };

  programs.virt-manager.enable = lib.mkIf (isx86 && libvirtdEnabled && isDesktop) true;

  environment = {
    sessionVariables = lib.mkIf libvirtdEnabled {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    systemPackages =
      lib.optionals dockerEnabled [
        pkgs.docker-buildx
        pkgs.docker-compose
      ]
      ++ lib.optionals (libvirtdEnabled && config.myConfig.virtualisation.libvirtd.swtpm) [
        pkgs.swtpm
      ];
  };
}
