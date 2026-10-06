{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    attic-client
    gitu
    just
    nil
    nix-output-monitor
    testdisk
    trash-cli
    treefmt
  ];
}
