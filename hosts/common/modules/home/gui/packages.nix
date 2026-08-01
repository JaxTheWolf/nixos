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
      gnome-tweaks
      libreoffice-fresh
      rquickshare
      seafile-client
      solaar
      telegram-desktop
      high-tide
      vlc
    ]
    ++ lib.optionals isx86 [
      cisco-packet-tracer_9
      discord
      gimp
      mission-center
      prismlauncher
      protonup-qt
      scrcpy
      vkbasalt
      wineWow64Packages.waylandFull
    ];
}
