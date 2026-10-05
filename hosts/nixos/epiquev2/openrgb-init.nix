{pkgs}:
pkgs.writeShellScript "set-openrgb-profile" ''
  HOUR=$(${pkgs.coreutils}/bin/date +%-H)
  if [ "$HOUR" -ge 7 ] && [ "$HOUR" -lt 22 ]; then
    PROFILE="yee-day"
  elif [ "$HOUR" -ge 22 ] && [ "$HOUR" -lt 23 ]; then
    PROFILE="yee"
  else
    PROFILE="yee-dank"
  fi
  ${pkgs.openrgb-with-all-plugins}/bin/openrgb -p "$PROFILE" 2>/dev/null || true
''
