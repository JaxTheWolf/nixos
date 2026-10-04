{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
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
    ];
  };
}
