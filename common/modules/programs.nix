{pkgs, ...}: {
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
