{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  programs = {
    bottom = {
      enable = true;
      settings = {
        flags = {
          rate = "500ms";
          battery = true;
          network_use_bytes = true;
          enable_cache_memory = true;
          is_list_ignored = true;
          list = ["virbr0.*"];
        };

        styles = {
          theme = "gruvbox";
        };

        row = [
          # --- TOP ROW ---
          {
            ratio = 35;
            child = [{type = "cpu";}];
          }

          # --- BOTTOM ROW ---
          {
            ratio = 65;
            child = [
              # --- LEFT COLUMN ---
              {
                ratio = 55;
                child =
                  [
                    {type = "disk";}
                    {type = "temp";}
                    {type = "net";}
                  ]
                  ++ lib.optionals (osConfig.networking.hostName == "dalaptop") [
                    {type = "batt";}
                  ];
              }

              # --- RIGHT COLUMN ---
              {
                ratio = 45;
                child = [
                  {type = "mem";}
                  {type = "proc";}
                ];
              }
            ];
          }
        ];
      };
    };

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

    ghostty = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        font-family = "FiraCode Nerd Font Mono";
        font-feature = "+calt +ccmp +ss10 +zero";
        font-size = 12;
        theme = "Night Lion V1";
        background-opacity = 0.8;
      };
    };

    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 10";
      };
      enable = true;
      flake = "${config.xdg.configHome}/nixos";
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

    zellij = {
      enable = true;

      settings = {
        pane_frames = false;
        default_shell = "zsh";
      };
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
