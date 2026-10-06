{
  pkgs,
  lib,
  config,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
  isDesktop = config.myConfig.desktop.enable or false;
in {
  programs =
    lib.mkMerge
    [
      {
        appimage = {
          enable = true;
          binfmt = true;
        };

        fuse.enable = true;
        zsh.enable = true;
        dconf.enable = true;

        nix-ld = {
          enable = true;
          libraries = [];
        };
      }
      (lib.mkIf (isx86 && isDesktop) {
        gamemode.enable = true;
        weylus.enable = true;
        gamescope.enable = true;

        steam = {
          dedicatedServer.openFirewall = true;
          enable = true;
          gamescopeSession.enable = true;
          protontricks.enable = true;
          remotePlay.openFirewall = true;
        };

        wireshark = {
          enable = true;
          package = pkgs.wireshark;
        };
      })
    ];
}
