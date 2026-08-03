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
        bat.enable = true;
        btop.enable = true;
        gnome.enable = isDesktop;
        helix.enable = true;
        ptyxis.profileUUIDs = ["57ff3f7eaa21025dead424d66a6cc57a" "110e7a2cb6318f5b41dd40966a3500ed" "9c09b769039b5190dfdda7766a38688b"];
        qt.enable = isDesktop;
        vesktop.enable = isDesktop;
        zellij.enable = true;

        firefox.enable = false;
        mangohud.enable = false;
      };
    };

  home.pointerCursor.enable = lib.mkIf isDesktop true;
}
