{pkgs, ...}: let
  devShellsDir = "$HOME/.config/nix-shells";
  nixConfigDir = "$HOME/.config/nixos";

  syncScript = pkgs.writeShellScript "sync-all-repos" ''
    # --- DRY Variables ---
    GIT="${pkgs.git}/bin/git"
    NOTIFY="${pkgs.libnotify}/bin/notify-send"

    repos=("${devShellsDir}" "${nixConfigDir}")

    for repo in "''${repos[@]}"; do
      echo "Syncing $repo..."

      if ! $GIT -C "$repo" pull --rebase --autostash; then
        $NOTIFY -u critical "Sync Failed" "Conflict or network error in $repo"
      else
        $GIT -C "$repo" add -N . 2>/dev/null || true
      fi
    done
  '';
in {
  systemd.user.services.sync-nix-repos = {
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

  systemd.user.timers.sync-nix-repos = {
    Unit.Description = "Hourly sync for all Nix repositories";
    Timer = {
      OnBootSec = "2m";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
