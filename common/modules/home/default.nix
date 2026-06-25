{inputs, ...}: {
  imports = [
    ./dconf
    ./programs
    ./activation.nix
    ./autostart.nix
    ./desktop-files.nix
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
