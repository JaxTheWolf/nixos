{pkgs, ...}: {
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "wg-auto-toggle" ''
        interface=$1
        action=$2

        NMCLI="${pkgs.networkmanager}/bin/nmcli"
        IP="${pkgs.iproute2}/bin/ip"
        LOGFILE="/tmp/wg-dispatcher.log"

        echo "[$(date)] Event: $action on $interface (ID: $CONNECTION_ID)" >> $LOGFILE

        # 1. PRE-UP: Instantly destroy the tunnel interfaces bypassing NM's D-Bus queue.
        # This guarantees the routing table is clean BEFORE connectivity checks begin,
        # without needing to background the task or risk a deadlock.
        if [ "$action" = "pre-up" ]; then
          $IP link delete wg-home 2>/dev/null || true
          $IP link delete wg-full 2>/dev/null || true
          exit 0
        fi

        # 2. DOWN: Handle full disconnections
        if [ "$action" = "down" ]; then
          (
            active_networks=$($NMCLI -g TYPE connection show --active 2>/dev/null | grep -E '802-11-wireless|802-3-ethernet')
            if [ -z "$active_networks" ]; then
              echo "[$(date)] No active networks. Tearing down all tunnels." >> $LOGFILE
              $NMCLI connection down wg-home 2>/dev/null || true
              $NMCLI connection down wg-full 2>/dev/null || true
            fi
          ) &
          exit 0
        fi

        # 3. UP: Evaluate and bring up the correct tunnel
        if [ "$action" = "up" ]; then
          (
            connection_type=$($NMCLI -g connection.type connection show "$CONNECTION_UUID" 2>/dev/null)

            if [ "$connection_type" != "802-3-ethernet" ] && [ "$connection_type" != "802-11-wireless" ]; then
              exit 0
            fi

            if [ "$connection_type" = "802-3-ethernet" ]; then
              echo "[$(date)] Ethernet connected. Forcing wg-full down, bringing up wg-home." >> $LOGFILE
              $NMCLI connection down wg-full 2>/dev/null || true
              $NMCLI connection up wg-home

            elif [ "$connection_type" = "802-11-wireless" ]; then

              case "$CONNECTION_ID" in
                "MERCUSYS_3C8A"|"MERCUSYS_3C8A_5G")
                  echo "[$(date)] Home WiFi matched ($CONNECTION_ID). Forcing both tunnels down." >> $LOGFILE
                  $NMCLI connection down wg-home 2>/dev/null || true
                  $NMCLI connection down wg-full 2>/dev/null || true
                  ;;
                *)
                  security=$($NMCLI -g 802-11-wireless-security.key-mgmt connection show "$CONNECTION_UUID" 2>/dev/null)
                  if [ -z "$security" ]; then
                    echo "[$(date)] Open WiFi detected. Forcing wg-home down, bringing up wg-full." >> $LOGFILE
                    $NMCLI connection down wg-home 2>/dev/null || true
                    $NMCLI connection up wg-full
                  else
                    echo "[$(date)] Secured WiFi detected. Forcing wg-full down, bringing up wg-home." >> $LOGFILE
                    $NMCLI connection down wg-full 2>/dev/null || true
                    $NMCLI connection up wg-home
                  fi
                  ;;
              esac
            fi
          ) &
          exit 0
        fi
      '';
    }
  ];
}
