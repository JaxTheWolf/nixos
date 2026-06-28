{config, ...}: {
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
          ignore_paths = [".trash" ".git" ".seafile-data" ".direnv" ".venv" ".nix-profile" ".nix-defexpr" "cache"];
        };
      };
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # antigravity-cli.enable = true;
    bat.enable = true;
    btop.enable = true;
    eza.enable = true;
    fd.enable = true;
    htop.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    zsh.enable = true;
  };
}
