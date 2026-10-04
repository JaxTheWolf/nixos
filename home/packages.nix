{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    attic-client
    binwalk
    gitu
    just
    nil
    nix-output-monitor
    testdisk
    trash-cli
    treefmt
  ];
}
