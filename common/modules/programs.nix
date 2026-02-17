{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs = {
    bat.enable = true;
    zsh.enable = true;
    gamemode.enable = true;
    firefox = {
      enable = true;
      languagePacks = [
        "cs"
        "en-GB"
        "en-US"
      ];
    };

    weylus.enable = true;
    gamescope.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 10";
      };
      enable = true;
      flake = "/etc/nixos";
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };

    steam = {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
  };
}
