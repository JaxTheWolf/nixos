{
  pkgs,
  lib,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    fuse = {
      enable = true;
    };

    zsh.enable = true;
    gamemode.enable = lib.mkIf isx86 true;

    weylus.enable = lib.mkIf isx86 true;
    gamescope.enable = lib.mkIf isx86 true;
    virt-manager.enable = lib.mkIf isx86 true;

    nix-ld = {
      enable = true;
      libraries = []; # with pkgs; [];
    };

    steam = lib.mkIf isx86 {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };

    wireshark = lib.mkIf isx86 {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
