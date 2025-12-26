{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    zram-generator
  ];

  services = {
    lact.enable = true;

    sshd.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
      xkb = {
        layout = "cz";
        variant = "";
      };
    };

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    hardware.openrgb.motherboard = "amd";
    hardware.openrgb.enable = true;

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

    journald.extraConfig = ''
      SystemMaxUse=2G
      RuntimeMaxUse=1G
      SystemMaxFiles=100
    '';

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
        enable = true;
        interval = "monthly";
      };
    };

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    fwupd.enable = true;
  };
}
