{...}: {
  imports = [
    ./dconf
    ./autostart.nix
    ./desktop-files.nix
    ./packages.nix
    ./programs.nix
  ];

  fonts.fontconfig.enable = true;
}
