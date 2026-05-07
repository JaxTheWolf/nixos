{pkgs, ...}: {
  xdg.configFile = {
    "autostart/01-openrgb.desktop".source = "${pkgs.openrgb}/share/applications/org.openrgb.OpenRGB.desktop";
    "autostart/01-zenmonitor.desktop".source = "${pkgs.zenmonitor}/share/applications/zenmonitor.desktop";
    "autostart/03-steam.desktop".source = "${pkgs.steam}/share/applications/steam.desktop";
  };
}
