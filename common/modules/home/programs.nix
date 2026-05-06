{
  pkgs,
  config,
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
                child = [
                  {type = "disk";}
                  {type = "temp";}
                  {type = "net";}
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
