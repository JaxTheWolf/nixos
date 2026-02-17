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

    virt-manager.enable = true;

    ccache = {
      enable = true;
      cacheDir = "/media/data/.ccache";
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
