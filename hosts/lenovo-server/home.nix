{pkgs, ...}: {
  imports = [
    ../common/modules/home/profiles/dnf-server.nix
  ];

  home.packages = with pkgs; [
    restic
  ];
}
