{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    binwalk
    gitu
    just
    nil
    nix-output-monitor
    testdisk
    tldr
    trash-cli
    treefmt
    yt-dlp
  ];
}
