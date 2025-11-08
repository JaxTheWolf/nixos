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

    flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        {
          appId = "com.mattjakeman.ExtensionManager";
          origin = "flathub";
        }
        {
          appId = "com.prusa3d.PrusaSlicer";
          origin = "flathub";
        }
        {
          appId = "com.github.tchx84.Flatseal";
          origin = "flathub";
        }
        {
          appId = "org.gtk.Gtk3theme.Adwaita-dark";
          origin = "flathub";
        }
        {
          appId = "org.gtk.Gtk3theme.Flat-Remix-GTK-Red-Darkest";
          origin = "flathub";
        }
        {
          appId = "com.github.iwalton3.jellyfin-media-player";
          origin = "flathub";
        }
        {
          appId = "org.freecad.FreeCAD";
          origin = "flathub";
        }
      ];
    };

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
  };

  systemd = {
    services."nix-prune-generations" = {
      description = "Keep only 5 system generations and run nix-collect-garbage";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations +5 || true
          ${pkgs.nix}/bin/nix-collect-garbage -d || true
        '';
        Nice = "10";
      };
    };

    timers."nix-prune-generations" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
  };
}
