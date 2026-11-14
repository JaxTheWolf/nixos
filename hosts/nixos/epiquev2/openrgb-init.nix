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

  sortedSchedules = lib.sort (a: b: a.time < b.time) schedules;
  defaultProfile = (lib.last sortedSchedules).profile;

  orgbScript = pkgs.writeShellScript "set-openrgb-profile" ''
    CURRENT_TIME=$(${pkgs.coreutils}/bin/date +%H:%M:%S)
    PROFILE="${defaultProfile}"

    ${lib.concatMapStringsSep "\n" (s: ''
        if [[ ! "$CURRENT_TIME" < "${s.time}" ]]; then
          PROFILE="${s.profile}"
        fi
      '')
      sortedSchedules}

    ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p "$PROFILE" 2>/dev/null || true
  '';
in {
  inherit schedules orgbScript;
}
