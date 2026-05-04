{pkgs, ...}: {
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "wg-auto-toggle" ''
        interface=$1
        action=$2

        NMCLI="${pkgs.networkmanager}/bin/nmcli"
        IP="${pkgs.iproute2}/bin/ip"
        LOGFILE="/tmp/wg-dispatcher.log"

        # --- DRY Functions ---
        log_msg() {
          echo "[$(date)] $1" >> "$LOGFILE"
        }

        down_tunnels() {
          $NMCLI connection down wg-home 2>/dev/null || true
          $NMCLI connection down wg-full 2>/dev/null || true
        }

        delete_tunnels() {
          $IP link delete wg-home 2>/dev/null || true
          $IP link delete wg-full 2>/dev/null || true
        }
        # ---------------------

        log_msg "Event: $action on $interface (ID: $CONNECTION_ID)"

        # 1. PRE-UP: Instantly destroy the tunnel interfaces
        if [ "$action" = "pre-up" ]; then
          delete_tunnels
          exit 0
        fi

        # 2. DOWN: Handle full disconnections
        if [ "$action" = "down" ]; then
          (
            active_networks=$($NMCLI -g TYPE connection show --active 2>/dev/null | grep -E '802-11-wireless|802-3-ethernet')
            if [ -z "$active_networks" ]; then
              log_msg "No active networks. Tearing down all tunnels."
              down_tunnels
            fi
          ) &
          exit 0
        fi

        # 3. UP: Evaluate and bring up the correct tunnel
        if [ "$action" = "up" ]; then
          (
            connection_type=$($NMCLI -g connection.type connection show "$CONNECTION_UUID" 2>/dev/null)

            # Exit if not ethernet or wifi
            [ "$connection_type" != "802-3-ethernet" ] && [ "$connection_type" != "802-11-wireless" ] && exit 0

            if [ "$connection_type" = "802-3-ethernet" ]; then
              log_msg "Ethernet connected. Bringing up wg-home."
              down_tunnels
              $NMCLI connection up wg-home

            elif [ "$connection_type" = "802-11-wireless" ]; then
              case "$CONNECTION_ID" in
                "MERCUSYS_3C8A"|"MERCUSYS_3C8A_5G")
                  log_msg "Home WiFi matched. Forcing both tunnels down."
                  down_tunnels
                  ;;
                *)
                  security=$($NMCLI -g 802-11-wireless-security.key-mgmt connection show "$CONNECTION_UUID" 2>/dev/null)

                  # Tear down existing before bringing up new
                  down_tunnels

                  if [ -z "$security" ]; then
                    log_msg "Open WiFi detected. Bringing up wg-full."
                    $NMCLI connection up wg-full
                  else
                    log_msg "Secured WiFi detected. Bringing up wg-home."
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
