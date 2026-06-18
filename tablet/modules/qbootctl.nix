{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.qbootctl];

  systemd.services.mark-boot-successful = {
    description = "Mark Qualcomm A/B boot slot as successful";

    wantedBy = ["multi-user.target"];

    after = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = "${pkgs.qbootctl}/bin/qbootctl -m";

      CapabilityBoundingSet = "CAP_SYS_ADMIN";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ReadWritePaths = ["/dev"];
    };
  };
}
