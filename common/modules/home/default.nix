{inputs, ...}: {
  imports = [
    ./programs
    ./activation.nix
    ./packages.nix
    ./services.nix
    inputs.filefinder.homeManagerModules.default
  ];

  home.stateVersion = "25.05";
  xdg.enable = true;
}
