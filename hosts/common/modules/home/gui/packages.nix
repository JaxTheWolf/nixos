{
  pkgs,
  lib,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  home.packages = with pkgs;
    [
      bubblemail
      czkawka-full
      element-desktop
      freerdp
      libreoffice-fresh
      rquickshare
      telegram-desktop
      vesktop
      vlc
    ]
    ++ lib.optionals isx86 [
      cisco-packet-tracer_9
      discord
      gimp
      inkscape
      # jetbrains.clion
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
