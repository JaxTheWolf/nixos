{...}: {
  imports = [
    ./packages.nix
    ./programs.nix
  ];

  xdg.enable = true;
}
