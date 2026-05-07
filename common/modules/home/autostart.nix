{pkgs, ...}: {
  xdg.configFile = {
    "autostart/01-bubblemaild.desktop".text = ''
      [Desktop Entry]
          Type=Application
          Name=Bubblemail Daemon
          Exec=${pkgs.bubblemail}/bin/bubblemaild
          Terminal=false
          StartupNotify=false
          X-GNOME-Autostart-enabled=true
    '';

    "autostart/02-solaar.desktop".source = "${pkgs.solaar}/share/applications/solaar.desktop";
    "autostart/03-seafile.desktop".source = "${pkgs.seafile-client}/share/applications/com.seafile.seafile-applet.desktop";
  };
}
