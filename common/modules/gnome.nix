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
      snapshot
      totem
      yelp
    ];

    systemPackages = with pkgs.gnomeExtensions; [
      alphabetical-app-grid
      appindicator
      blur-my-shell
      control-monitor-brightness-and-volume-with-ddcutil
      bubblemail
      color-picker
      dash-to-dock
      # favorites-to-applications-grid
      middle-click-to-close-in-overview
      undecorate
      user-themes
      window-is-ready-remover
      solaar-extension
    ];
  };
}
