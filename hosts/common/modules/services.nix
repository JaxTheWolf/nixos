{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    sshd.enable = true;

    blueman.enable = lib.mkIf (config.myConfig.hardware.bluetooth.enable && config.myConfig.desktop.enable) true;

    geoclue2.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.brlaser
      ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    journald.settings.Journal = {
      SystemMaxUse = "2G";
      RuntimeMaxUse = "1G";
      SystemMaxFiles = "100";
    };

    zram-generator = {
      enable = true;
      settings = {
        "zram0" = {
          "zram-size" = "ram*1.5";
          "compression-algorithm" = "zstd";
        };
      };
    };

    btrfs = {
      autoScrub = {
        enable = lib.any (fs: fs.fsType == "btrfs") (lib.attrValues config.fileSystems);
        interval = "monthly";
      };
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    kmscon = {
      enable = true;
      config = {
        hwaccel = true;
      };
      useXkbConfig = true;
    };

    fwupd.enable = true;

    udev.packages = with pkgs; [
      platformio-core.udev
      openocd
    ];
  };
}
