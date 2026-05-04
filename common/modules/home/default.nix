{...}: {
  imports = [
    ./dconf
    ./desktop-files.nix
    ./packages.nix
    ./programs.nix
    ./starship.nix
    ./services.nix
    ./zsh.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
