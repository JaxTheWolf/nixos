{
  pkgs,
  ...
}:
{
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    pd.enable = true;

    settings = {
      TLP_AUTO_SWITCH = 1;

      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";
      CPU_DRIVER_OPMODE_ON_SAV = "active";
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      MEM_SLEEP_ON_BAT = "deep";
    };
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };
    };
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=5min
  '';

  systemd.services.disable-problematic-wakeup = {
    description = "Disable only specific noisy wakeup sources";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'for device in XHC RP09 RP10 RP13; do if grep -q \"$device.*enabled\" /proc/acpi/wakeup; then echo $device > /proc/acpi/wakeup; fi; done'";
    };
  };
}
