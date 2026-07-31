{inputs, ...}: {
  imports = [
    inputs.stylix.homeModules.stylix
    ./dconf
    ./autostart.nix
    ./desktop-files.nix
    ./packages.nix
    ./programs.nix
    ./theming.nix
  ];

  fonts.fontconfig.enable = true;
}
