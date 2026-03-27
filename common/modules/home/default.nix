{...}: {
  imports = [
    ./dconf
    ./desktop-files.nix
    ./starship.nix
    ./services.nix
    ./zsh.nix
  ];

  xdg.enable = true;

  home.stateVersion = "25.05";
}
