{
  pkgs,
  config,
  lib,
  ...
}: {
  home.activation = {
    cloneRepos = lib.hm.dag.entryAfter ["writeBoundary"] ''
      GIT="${pkgs.git}/bin/git"
      CONFIG_DIR="${config.xdg.configHome}"

      # Repo URLs
      SHELLS_URL="https://github.com/YourUsername/nix-shells.git"
      NIXOS_URL="https://github.com/JaxTheWolf/nixos.git"

      # 1. Clone nix-shells
      if [ ! -d "$CONFIG_DIR/nix-shells/.git" ]; then
        echo "Cloning nix-shells repository..."
        $DRY_RUN_CMD $GIT clone "$SHELLS_URL" "$CONFIG_DIR/nix-shells"
      fi

      # 2. Clone nixos config (Useful for fresh installs!)
      if [ ! -d "$CONFIG_DIR/nixos/.git" ]; then
        echo "Cloning nixos repository..."
        $DRY_RUN_CMD $GIT clone "$NIXOS_URL" "$CONFIG_DIR/nixos"
      fi
    '';
  };
}
