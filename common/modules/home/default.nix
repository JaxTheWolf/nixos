{...}: {
  imports = [
    ./dconf
    ./programs
    ./activation.nix
    ./autostart.nix
    ./desktop-files.nix
    ./packages.nix
    ./services.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
