{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.myConfig.desktop.gnome.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome.gnome-keyring.enable = true;

      xserver = {
        enable = true;
        exportConfiguration = true;
        excludePackages = with pkgs; [
          xterm
        ];
      };
    };

    environment = {
      gnome.excludePackages = with pkgs; [
        decibels
        epiphany
        geary
        gnome-connections
        gnome-console
        gnome-contacts
        gnome-logs
        gnome-maps
        gnome-music
        gnome-software
        gnome-system-monitor
        gnome-tour
        showtime
        snapshot
        totem
        yelp
      ];

      systemPackages =
        [
          pkgs.gnome-tweaks
        ]
        ++ (with pkgs.gnomeExtensions; [
          alphabetical-app-grid
          appindicator
          bluetooth-quick-connect
          blur-my-shell
          bubblemail
          caffeine
          color-picker
          dash-to-dock
          middle-click-to-close-in-overview
          quick-settings-audio-panel
          solaar-extension
          undecorate
          user-themes
          window-is-ready-remover
        ]);
    };
  };
}
