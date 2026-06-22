{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./bottom.nix
    ./helix.nix
    ./starship.nix
    ./zellij.nix
    ./zsh.nix
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    filefinder = {
      enable = true;
      settings = {
        search.multithreaded_search = true;
        index = {
          index_threads = 0;
          ignore_trash = true;
        };
      };
    };

    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      languagePacks = [
        "cs"
        "en-GB"
        "en-US"
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
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

    vscode = lib.mkIf pkgs.stdenv.hostPlatform.isx86_64 {
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    antigravity-cli.enable = true;
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    fd.enable = true;
    htop.enable = true;
    jq.enable = true;
    ptyxis.enable = true;
    ripgrep.enable = true;
    thunderbird.enable = true;
    zsh.enable = true;
  };
}
