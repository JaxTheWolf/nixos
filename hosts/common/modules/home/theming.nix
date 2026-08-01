{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  isDesktop = osConfig.myConfig.desktop.enable or false;
in {
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/primer-dark.yaml";

    image = pkgs.fetchurl {
      url = "https://d.furaffinity.net/art/-lofi/1580026261/1579917351.-lofi_1-14-20b.jpg";
      hash = "sha256-yf6ifIWKwHdG/5VelXpwPhLPD2XxFVaFZVGD/V+u118=";
    };

    cursor = lib.mkIf isDesktop {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    icons = lib.mkIf isDesktop {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 10;
      };
    };

    targets = {
      qt.enable = isDesktop;
      firefox.enable = false;
      ptyxis.profileUUIDs = ["57ff3f7eaa21025dead424d66a6cc57a"];
      vesktop.enable = isDesktop;
      bat.enable = true;
      btop.enable = true;
      helix.enable = true;
      zellij.enable = true;
    };
  };

  home.pointerCursor.enable = lib.mkIf isDesktop true;
}
