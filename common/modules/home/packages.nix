{
  pkgs,
  lib,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  home.packages = with pkgs;
    [
      alejandra
      binwalk
      bubblemail
      czkawka-full
      element-desktop
      freerdp
      gitu
      just
      libreoffice-fresh
      nil
      nix-output-monitor
      rquickshare
      telegram-desktop
      testdisk
      tldr
      trash-cli
      treefmt
      vesktop
      vlc
      yt-dlp
    ]
    ++ lib.optionals isx86 [
      cisco-packet-tracer_9
      discord
      gimp
      inkscape
      jetbrains.clion
      mangohud
      mission-center
      prismlauncher
      protonup-qt
      scrcpy
      tidal-hifi
      vkbasalt
      wineWow64Packages.waylandFull
    ];
}
