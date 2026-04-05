{...}: {
  imports = [
    ./flatpak.nix
    ./gnome.nix
    ./nm-dispatch-scripts.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
  ];
}
