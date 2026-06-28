{pkgs, ...}: {
  environment.variables = {
    GSK_RENDERER = "gl";
  };

  boot = {
    kernelModules = ["g_ether"];
    kernelParams = ["console=ttyGS0"];

    initrd.systemd = {
      initrdBin = [
        pkgs.util-linux
        pkgs.busybox
      ];

      emergencyAccess = true;
    };
  };

  systemd.services."serial-getty@ttyGS0" = {
    enable = true;
    wantedBy = ["getty.target"];
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.localCommands = ''
    ${pkgs.iproute2}/bin/ip addr add 192.168.7.2/24 dev usb0 || true
    ${pkgs.iproute2}/bin/ip link set dev usb0 up || true
  '';
}
