{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  programs = {
    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      languagePacks = [
      ];
    };

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
      flake = "${config.xdg.configHome}/nixos";
    };
    htop.enable = true;
  };
}
