{
  lib,
  ...
}:

{
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
      autohide-in-fullscreen = false;
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
      max-alpha = 0.6;
      middle-click-action = "launch";
      min-alpha = 0.10;
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
      pipelines = lib.hm.gvariant.mkValue ''
        {
          'pipeline_default': {
            'name': <'Default'>, 
            'effects': <[
              {
                'type': <'native_static_gaussian_blur'>, 
                'id': <'effect_27049338116840'>, 
                'params': <@a{sv} {}>
              }, 
              {
                'type': <'noise'>, 
                'id': <'effect_90950561821691'>, 
                'params': <{'lightness': <0.64>, 'noise': <0.25>}>
              }
            ]>
          }, 
          'pipeline_default_rounded': {
            'name': <'Default rounded'>, 
            'effects': <[
              {
                'type': <'native_static_gaussian_blur'>, 
                'id': <'effect_000000000001'>, 
                'params': <{'radius': <30>, 'brightness': <0.6>}>
              }, 
              {
                'type': <'corner'>, 
                'id': <'effect_000000000002'>, 
                'params': <{'radius': <24>}>
              }
            ]>
          }
        }
      '';
    };

    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = false;
      brightness = 1.0;
      opacity = 217;
      whitelist = [ "org.gnome.Console" ];
    };

    "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
      blur = false;
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
      brightness = 0.6;
      pipeline = "pipeline_default_rounded";
      sigma = 30;
      static-blur = false;
      style-dash-to-dock = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/overview" = {
      pipeline = "pipeline_default";
      style-components = 2;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      brightness = 0.6;
      force-light-text = false;
      pipeline = "pipeline_default";
      sigma = 30;
      static-blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
      pipeline = "pipeline_default";
    };

    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.6;
      sigma = 30;
    };

    "org/gnome/shell/ectensions/bubblemail" = {
      newest-first = true;
    };
  };
}
