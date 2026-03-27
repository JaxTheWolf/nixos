{pkgs, ...}: {
  systemd.user.services.sync-dev-shells = {
    Unit = {
      Description = "Background sync for Nix dev shells repository";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };

    Service = {
      Type = "oneshot";
      WorkingDirectory = "%h/.config/nix-shells";

      ExecStart = ''
        ${pkgs.bash}/bin/bash -c " \
          ${pkgs.git}/bin/git pull --rebase --autostash || \
          ${pkgs.libnotify}/bin/notify-send -u critical 'Sync Failed' 'Nix dev shells encountered a git conflict or network error.' \
        "
      '';

      PassEnvironment = ["DBUS_SESSION_BUS_ADDRESS" "DISPLAY"];
    };
  };

  systemd.user.timers.sync-dev-shells = {
    Unit = {
      Description = "Check for dev shell updates every hour";
    };

    Timer = {
      OnBootSec = "2m";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
