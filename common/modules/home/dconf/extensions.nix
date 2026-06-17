{...}: {
  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = "Flat-Remix-Darkest-fullPanel";
    };

    "org/gnome/shell/extensions/thanatophobia" = {
      year = 2004;
      month = 11;
      day = 23;
      hour = 12;
      minute = 0;
      sex = 1;
      expectancy = 74.11;
      rounding = 7;
      country = "CZE";
      countdown = 0;
    };

    "org/gnome/shell/extensions/appindicator" = {
      icon-brightness = 0.0;
      icon-contrast = 0.0;
      icon-opacity = 240;
      icon-saturation = 0.0;
      icon-size = 0;
      legacy-tray-enabled = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      autohide-in-fullscreen = true;
      background-color = "rgb(0,0,0)";
      background-opacity = 0.8;
      click-action = "skip";
      custom-background-color = true;
      custom-theme-shrink = true;
      customize-alphas = true;
      dash-max-icon-size = 28;
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      hide-tooltip = false;
      intellihide-mode = "ALL_WINDOWS";
      isolate-workspaces = true;
      max-alpha = 0.4;
      middle-click-action = "launch";
      min-alpha = 0.05;
      preferred-monitor = -2;
      preview-size-scale = 0.5;
      running-indicator-style = "DOTS";
      scroll-action = "cycle-windows";
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-apps-at-top = true;
      show-mounts-network = true;
      transparency-mode = "DYNAMIC";
    };

    "org/gnome/shell/extensions/bluetooth-quick-connect" = {
      show-battery-value-on = true;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = 2;
      rounded-blur-found = false;
      hacks-level = 1;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = true;
      blur-on-overview = true;
      dynamic-opacity = true;
      enable-all = false;
      opacity = 255;
      pipeline = "pipeline_default";
      sigma = 1;
      static-blur = false;
      whitelist = ["com.mitchellh.ghostty"];
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
      pipeline = "pipeline_default";
      static-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
      style-components = 3;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      pipeline = "pipeline_default";
      static-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/bubblemail" = {
      newest-first = true;
    };

    "org/gnome/shell/extensions/quick-settings-audio-panel" = {
      create-applications-volume-sliders = true;
      create-balance-slider = false;
      create-mpris-controllers = false;
      create-perdevice-volume-sliders = false;
      group-applications-volume-sliders = true;
      panel-type = "merged-panel";
    };
  };
}
