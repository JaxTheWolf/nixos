{
  pkgs,
  config,
  lib,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  programs = {
    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      languagePacks = [
        "cs"
        "en-GB"
        "en-US"
      ];
    };

    vscode = lib.mkIf isx86 {
      enable = true;
      package = pkgs.vscode.fhsWithPackages (
        ps:
          with ps; [
            python3
            zlib
            gcc
            gnumake
          ]
      );
    };

    ptyxis.enable = true;
    thunderbird.enable = true;
  };
}
