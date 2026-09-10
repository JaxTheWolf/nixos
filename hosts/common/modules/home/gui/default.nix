{...}: {
  imports = [
    ./dconf
    ./autostart.nix
    ./desktop-files.nix
    ./packages.nix
    ./programs.nix
  ];

  xdg.terminal-exec = {
    enable = true;
    settings = {
      GNOME = [
        "org.gnome.Ptyxis.desktop:new-window"
      ];
      default = [
        "org.gnome.Ptyxis.desktop:new-window"
      ];
    };
  };

  fonts.fontconfig.enable = true;
}
