{pkgs, ...}: let
  devShellsDir = "$HOME/.config/nix-shells";
  nixConfigDir = "/etc/nixos";

  syncScript = pkgs.writeShellScript "sync-all-repos" ''
    repos=("${devShellsDir}" "${nixConfigDir}")

    for repo in "''${repos[@]}"; do
      echo "Syncing $repo..."
      if ! ${pkgs.git}/bin/git -C "$repo" pull --rebase --autostash; then
        ${pkgs.libnotify}/bin/notify-send -u critical "Sync Failed" "Conflict or network error in $repo"
      else
        ${pkgs.git}/bin/git -C "$repo" add -N . 2>/dev/null || true
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
