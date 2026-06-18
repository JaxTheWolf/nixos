{
  pkgs,
  lib,
  ...
}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    fuse = {
      enable = true;
    };

    zsh.enable = true;
    gamemode.enable = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 true;

    weylus.enable = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 true;
    gamescope.enable = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 true;
    virt-manager.enable = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [];
    };

    steam = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
