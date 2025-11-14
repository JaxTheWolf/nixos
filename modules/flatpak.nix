{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      {
        appId = "com.mattjakeman.ExtensionManager";
        origin = "flathub";
      }
      {
        appId = "com.prusa3d.PrusaSlicer";
        origin = "flathub";
      }
      {
        appId = "com.github.tchx84.Flatseal";
        origin = "flathub";
      }
      {
        appId = "org.gtk.Gtk3theme.Adwaita-dark";
        origin = "flathub";
      }
      {
        appId = "org.gtk.Gtk3theme.Flat-Remix-GTK-Red-Darkest";
        origin = "flathub";
      }
      {
        appId = "com.github.iwalton3.jellyfin-media-player";
        origin = "flathub";
      }
      {
        appId = "org.freecad.FreeCAD";
        origin = "flathub";
      }
    ];
  };
}
