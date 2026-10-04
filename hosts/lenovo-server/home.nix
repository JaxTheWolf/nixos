{pkgs, ...}: {
  imports = [
    ../../home/profiles/dnf-server.nix
  ];

  home.packages = with pkgs; [
    restic
  ];
}
