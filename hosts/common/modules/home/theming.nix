{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  sharedTheme = import ../../theming-shared.nix {inherit pkgs;};
  isDesktop = osConfig.myConfig.desktop.enable or false;
in {
  stylix =
    sharedTheme
    // {
      cursor = lib.mkIf isDesktop sharedTheme.cursor;
      icons = lib.mkIf isDesktop {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
      targets = {
        gnome.enable = isDesktop;
        qt.enable = isDesktop;
        firefox.enable = false;
        ptyxis.profileUUIDs = ["57ff3f7eaa21025dead424d66a6cc57a" "110e7a2cb6318f5b41dd40966a3500ed" "9c09b769039b5190dfdda7766a38688b"];
        vesktop.enable = isDesktop;
        bat.enable = true;
        btop.enable = true;
        helix.enable = true;
        zellij.enable = true;
      };
    };

  home.pointerCursor.enable = lib.mkIf isDesktop true;
}
