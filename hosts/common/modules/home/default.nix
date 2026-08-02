{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.filefinder.homeManagerModules.default
    ./programs
    ./activation.nix
    ./packages.nix
    ./services.nix
    ./theming.nix
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
