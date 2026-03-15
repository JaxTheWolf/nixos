{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment = {
    gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      geary
      gnome-connections
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      gnome-software
      gnome-system-monitor
      showtime
      snapshot
      totem
      yelp
    ];

    systemPackages = with pkgs.gnomeExtensions; [
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
    ];
  };

  services.gnome.gnome-keyring.enable = true;
}
