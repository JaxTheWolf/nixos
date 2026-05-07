{pkgs, ...}: {
  xdg.configFile = {
    "autostart/01-zenmonitor.desktop".source = "${pkgs.zenmonitor}/share/applications/zenmonitor.desktop";

    "autostart/01-openrgb.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenRGB
      Exec=${pkgs.openrgb}/bin/openrgb --startminimized
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';

    "autostart/03-steam.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Steam
      Exec=steam -silent
      Icon=steam
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';
  };
}
