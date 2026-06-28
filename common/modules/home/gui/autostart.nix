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

    "autostart/02-solaar.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Solaar
      # Point directly to the binary in the Nix store and add your flags
      Exec=${pkgs.solaar}/bin/solaar --window=hide
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';

    "autostart/03-seafile.desktop".source = "${pkgs.seafile-client}/share/applications/com.seafile.seafile-applet.desktop";
  };
}
