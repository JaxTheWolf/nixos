{
  config,
  lib,
  ...
}:
lib.mkIf config.myConfig.hardware.power.enable {
  powerManagement.powertop.enable = lib.mkDefault true;
  services = {
    thermald.enable = lib.mkDefault true;
    power-profiles-daemon.enable = lib.mkForce false;
    tlp = {
      enable = lib.mkDefault true;
      pd.enable = lib.mkDefault true;
      settings = lib.mkDefault {
        TLP_ENABLE = 1;
        TLP_AUTO_SWITCH = 1;

        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_DRIVER_OPMODE_ON_BAT = "active";
        CPU_DRIVER_OPMODE_ON_SAV = "active";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 100;
        NMI_WATCHDOG = 0;

        PCIE_ASPM_ON_BAT = "powersave";
        RUNTIME_PM_ON_BAT = "auto";

        AHCI_RUNTIME_PM_ON_BAT = "auto";
        SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
        USB_AUTOSUSPEND = 1;

        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        MEM_SLEEP_ON_BAT = "deep";
      };
    };

    logind = {
      settings = lib.mkDefault {
        Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "suspend";
          HandleLidSwitchDocked = "ignore";
        };
      };
    };
  };

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = lib.mkDefault "5min";
  };
}
