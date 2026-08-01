{
  inputs,
  config,
  ...
}: {
  imports = [
    ./programs
    ./activation.nix
    ./packages.nix
    ./services.nix
    inputs.filefinder.homeManagerModules.default
  ];

  home = {
    stateVersion = "25.05";

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "/usr/local/LinkServer"
    ];

    sessionVariables = {
      FLAKE = "${config.xdg.configHome}/nixos";
    };
  };
}
