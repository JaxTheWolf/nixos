{
  lib,
  ...
}:

{
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = lib.mkAfter [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Shift><Control><Alt>Home";
      command = "ddcutil setvcp 10 + 10";
      name = "Bright Up";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      binding = "<Shift><Control><Alt>End";
      command = "ddcutil setvcp 10 - 10";
      name = "Bright Down";
    };
  };
}
