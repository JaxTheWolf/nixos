{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
  role = osConfig.myConfig.role or "";
in {
  home.packages = with pkgs;
    [
      bubblemail
      czkawka-full
      element-desktop
      freerdp
      libreoffice-stable
      prusa-slicer
      rquickshare
      seafile-client
      solaar
      sone
      telegram-desktop
      vlc
    ]
    ++ lib.optionals (builtins.elem role ["desktop" "laptop"] && isx86) [
      binwalk
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
