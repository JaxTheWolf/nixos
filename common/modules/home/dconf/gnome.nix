{
  lib,
  ...
}:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      accent-color = "red";
      clock-format = "24h";
      clock-show-seconds = true;
      color-scheme = "prefer-dark";
      cursor-size = 24;
      cursor-theme = "Bibata-Modern-Classic";
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Flat-Remix-GTK-Red-Darkest";
      icon-theme = "Papirus-Dark";
      show-battery-percentage = true;
      toolkit-accessibility = true;
      overlay-scrolling = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      natural-scroll = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file:///home/jax/.config/background";
      picture-uri-dark = "file:///home/jax/.config/background";
    };

    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-left = [ "<Shift><Control><Super>Left" ];
      move-to-workspace-right = [ "<Shift><Control><Super>Right" ];
      switch-to-workspace-left = [ "<Control><Super>Left" ];
      switch-to-workspace-right = [ "<Control><Super>Right" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-fullscreen = [ "<Super>F11" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,close";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.mkBefore [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "kgx";
      name = "Terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "Filus Managus";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      experimental-features = [
        "scale-monitor-framebuffer"
        "variable-refresh-rate"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      favorite-apps = [
        "vesktop.desktop"
        "org.gnome.Nautilus.desktop"
        "steam.desktop"
        "firefox.desktop"
        "org.telegram.desktop.desktop"
        "org.gnome.Console.desktop"
        "io.missioncenter.MissionCenter.desktop"
        "tidal-hifi.desktop"
      ];
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };

    "org/gnome/system/location" = {
      enabled = false;
    };
  };
}
