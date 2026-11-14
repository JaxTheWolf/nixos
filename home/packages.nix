{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    attic-client
    gitu
    just
    nil
    nix-output-monitor
    prusa-slicer
    testdisk
    trash-cli
    treefmt
  ];
}
