{
  pkgs,
  lib,
}: let
  schedules = [
    {
      name = "day";
      profile = "yee-day";
      time = "07:00:00";
    }
    {
      name = "night";
      profile = "yee";
      time = "20:00:00";
    }
    {
      name = "dank";
      profile = "yee-dank";
      time = "23:00:00";
    }
  ];

  orgbScript = pkgs.writeShellScript "set-openrgb-profile" ''
    HOUR=$(${pkgs.coreutils}/bin/date +%-H)
    MINUTE=$(${pkgs.coreutils}/bin/date +%-M)
    CURRENT_MINS=$(( HOUR * 60 + MINUTE ))

    ${lib.concatMapStringsSep "\n" (
        s: ''
          SCHED_H="10#${builtins.substring 0 2 s.time}"
          SCHED_M="10#${builtins.substring 3 2 s.time}"
          SCHED_MINS=$(( SCHED_H * 60 + SCHED_M ))

          if [ "$CURRENT_MINS" -ge $SCHED_MINS ]; then
            PROFILE="${s.profile}"
          fi
        ''
      ) (lib.sort (a: b: a.time < b.time)
        schedules)}

    ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p "$PROFILE" 2>/dev/null || true
  '';
in {
  inherit schedules orgbScript;
}
