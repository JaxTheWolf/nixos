{
  pkgs,
  config,
  osConfig,
  ...
}: let
  devShellsDir = "${config.xdg.configHome}/nix-shells";
  nixConfigDir = "${config.xdg.configHome}/nixos";
  isDesktop = osConfig.myConfig.desktop.enable or false;

  syncScript = pkgs.writeShellScript "sync-all-repos" ''
    # --- DRY Variables ---
    GIT="${pkgs.git}/bin/git"

    repos=("${devShellsDir}" "${nixConfigDir}")

    for repo in "''${repos[@]}"; do
      echo "Syncing $repo..."

      if ! $GIT -C "$repo" pull --rebase --autostash; then
      ${
      if isDesktop
      then ''
        ${pkgs.libnotify}/bin/notify-send -u critical "Sync Failed" "Conflict or network error in $repo"
      ''
      else ''
        echo "ERROR: Sync Failed - Conflict or network error in $repo" >&2
      ''
    }
      else
        $GIT -C "$repo" add -N . 2>/dev/null || true
      fi
    done
  '';
in {
  systemd.user = {
    services.sync-nix-repos = {
      Unit = {
        Description = "Background sync for Nix Config and Dev Shells";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${syncScript}";
        PassEnvironment = ["DBUS_SESSION_BUS_ADDRESS" "DISPLAY"];
      };
    };

    timers.sync-nix-repos = {
      Unit.Description = "Hourly sync for all Nix repositories";
      Timer = {
        OnBootSec = "20s";
        OnUnitActiveSec = "1h";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
