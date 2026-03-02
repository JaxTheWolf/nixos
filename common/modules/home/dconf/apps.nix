{
  lib,
  ...
}:

{
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    "org/gnome/Console" = {
      custom-font = lib.mkDefault "FiraCode Nerd Font Mono 11";
      use-system-font = false;
    };

    "org/gnome/TextEditor" = {
      custom-font = lib.mkDefault "Fira Code weight=450 11";
      use-system-font = false;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      recursive-search = "always";
      search-filter-time-type = "last_modified";
      show-directory-item-counts = "always";
      show-image-thumbnails = "always";
    };
  };
}
