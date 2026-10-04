{...}: {
  imports = [
    ../options.nix
    ./boot.nix
    ./flatpak.nix
    ./gnome.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./packages.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./virtualisation.nix
  ];
}
