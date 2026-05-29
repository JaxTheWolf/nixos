{...}: {
  imports = [
    ./dconf
    ./activation.nix
    ./autostart.nix
    ./desktop-files.nix
    ./packages.nix
    ./programs.nix
    ./starship.nix
    ./services.nix
    ./zsh.nix
  ];

  xdg.enable = true;

  home.enableNixpkgsReleaseCheck = false; # For now. (nixpkgs is 26.11, but home-manager is still on 25.05)

  home.stateVersion = "25.05";
}
