{inputs, ...}: {
  imports = [
    ./programs
    ./activation.nix
    ./packages.nix
    ./services.nix
    inputs.filefinder.homeManagerModules.default
  ];

  home = {
    username = "jax";
    homeDirectory = "/home/jax";
    stateVersion = "25.05";
  };

  xdg.enable = true;
}
