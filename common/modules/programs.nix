{
  config,
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
    gamemode.enable = true;

    weylus.enable = true;
    gamescope.enable = true;
    virt-manager.enable = true;

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
      libraries = with pkgs; [];
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
