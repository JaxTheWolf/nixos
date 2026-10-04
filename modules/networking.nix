{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myConfig.networking.wgAutoToggle;
  homeSsidPattern = lib.concatStringsSep "|" (map (s: "\"${s}\"") cfg.homeSsids);

  wgAutoToggleScript = pkgs.writeShellScript "wg-auto-toggle" ''
    interface=$1
    action=$2

    NMCLI="${pkgs.networkmanager}/bin/nmcli"
    IP="${pkgs.iproute2}/bin/ip"
    LOGGER="${pkgs.util-linux}/bin/logger -t wg-dispatcher"

    log_msg() {
      $LOGGER "$1"
    }

    down_tunnels() {
      $NMCLI connection down wg-home 2>/dev/null || true
      $NMCLI connection down wg-full 2>/dev/null || true
    }

    delete_tunnels() {
      $IP link delete wg-home 2>/dev/null || true
      $IP link delete wg-full 2>/dev/null || true
    }

    log_msg "Event: $action on $interface (ID: $CONNECTION_ID)"

    # 1. PRE-UP: Destroy stale tunnel interfaces
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

        [ "$connection_type" != "802-3-ethernet" ] && [ "$connection_type" != "802-11-wireless" ] && exit 0

        if [ "$connection_type" = "802-3-ethernet" ]; then
          log_msg "Ethernet connected. Bringing up wg-home."
          down_tunnels
          $NMCLI connection up wg-home
        elif [ "$connection_type" = "802-11-wireless" ]; then
          case "$CONNECTION_ID" in
            ${homeSsidPattern})
              log_msg "Home WiFi matched. Forcing both tunnels down."
              down_tunnels
              ;;
            *)
              security=$($NMCLI -g 802-11-wireless-security.key-mgmt connection show "$CONNECTION_UUID" 2>/dev/null)
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
in {
  networking = {
    firewall.enable = false;

    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];

      dispatcherScripts = lib.optionals cfg.enable [
        {
          source = wgAutoToggleScript;
        }
      ];

      ensureProfiles.profiles = {
        "VSB-VPN" = {
          connection = {
            id = "VSB-VPN";
            type = "vpn";
            autoconnect = "false";
          };
          vpn = {
            service-type = "org.freedesktop.NetworkManager.openconnect";
            gateway = "vpn.vsb.cz";
            protocol = "anyconnect";
            useragent = "AnyConnect";
            gateway-flags = "0";
            gwcert-flags = "0";
            cookie-flags = "0";
          };
        };
      };
    };
  };
}
