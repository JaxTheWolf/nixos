{
  pkgs,
  config,
  ...
}: {
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
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
      flake = "/etc/nixos";
    };

    vscode = {
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

    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    htop.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    thunderbird.enable = true;
    zsh.enable = true;
  };
}
