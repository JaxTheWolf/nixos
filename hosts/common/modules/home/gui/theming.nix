{pkgs, ...}: {
  gtk = {
    enable = true;
    theme = {
      name = "Flat-Remix-GTK-Red-Darkest";
      package = pkgs.flat-remix-gtk;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # font = {
    #   name = "Sans";
    #   size = 11;
    # };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };
}
