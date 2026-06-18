{pkgs, ...}: {
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    fuse = {
      enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [];
    };

    zsh.enable = true;
  };
}
