_: {
  networking.networkmanager.ensureProfiles = {
    profiles = {
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
}
