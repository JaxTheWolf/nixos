{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    dconf.profiles.gdm.databases = [
      {
        settings = {
          "org/gnome/desktop/peripherals/keyboard" = {
            numlock-state = true;
            remember-numlock-state = true;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            speed-profile = "flat";
            speed = -0.5;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            speed-profile = "flat";
            speed = -0.5;
          };

          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Flat-Remix-GTK-Red-Darkest";
            icon-theme = "Papirus-Dark";
            cursor-theme = "Bibata-Modern-Classic";
            clock-format = "24h";
          };

          "org/gnome/shell/portal" = {
            color-scheme = "prefer-dark";
          };
        };
      }
    ];

    adb.enable = true;
    bat.enable = true;
    zsh.enable = true;
    gamemode.enable = true;
    firefox.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 10";
      };
      enable = true;
      flake = "/etc/nixos";
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
    # obs-studio = {
    #   enable = true;
    #   plugins = with pkgs.obs-studio-plugins; [
    #     obs-vaapi
    #     obs-vkcapture
    #     wlrobs
    #   ];
    # };

    steam = {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    virt-manager.enable = true;
  };

  services.flatpak = {
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
}
