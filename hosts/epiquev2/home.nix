{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-gstreamer
      obs-pipewire-audio-capture
      obs-vaapi
      obs-vkcapture
      wlrobs
    ];
  };

  xdg.configFile = {
    "autostart/01-zenmonitor.desktop".source = "${pkgs.zenmonitor}/share/applications/zenmonitor.desktop";

    "autostart/01-openrgb.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenRGB
      Exec=${pkgs.openrgb-with-all-plugins}/bin/openrgb --startminimized --profile "yee"
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
