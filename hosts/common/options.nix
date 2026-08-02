{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options.myConfig = {
    role = mkOption {
      type = types.enum ["workstation" "laptop" "tablet" "server"];
      default = "workstation";
      description = "Host role profile";
    };

    user = {
      name = mkOption {
        type = types.str;
        default = "jax";
        description = "Primary user account name";
      };
      description = mkOption {
        type = types.str;
        default = "Roman Lubij";
        description = "Primary user full name";
      };
    };

    desktop = {
      enable = mkOption {
        type = types.bool;
        default = config.myConfig.role != "server";
        description = "Enable desktop environment and GUI apps";
      };

      gnome = {
        enable = mkOption {
          type = types.bool;
          default = config.myConfig.desktop.enable;
          description = "Enable GNOME desktop environment";
        };
      };

      flatpak = {
        enable = mkOption {
          type = types.bool;
          default = config.myConfig.desktop.enable;
          description = "Enable Flatpak package manager";
        };
      };
    };

    hardware = {
      gpu = mkOption {
        type = types.enum ["none" "amd" "intel" "nvidia"];
        default = "none";
        description = "Hardware GPU acceleration profile";
      };

      cpu = mkOption {
        type = types.enum ["none" "amd" "intel"];
        default = "none";
        description = "CPU vendor profile";
      };

      power = {
        enable = mkOption {
          type = types.bool;
          default = config.myConfig.role == "laptop";
          description = "Enable laptop power management (TLP, thermald)";
        };
      };

      bluetooth = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Bluetooth stack";
        };
      };

      logitech = {
        enable = mkOption {
          type = types.bool;
          default = config.myConfig.desktop.enable;
          description = "Enable Logitech wireless hardware support (Solaar)";
        };
      };
    };

    virtualisation = {
      docker = {
        enable = mkOption {
          type = types.bool;
          default = config.myConfig.desktop.enable;
          description = "Enable Docker daemon";
        };
      };

      libvirtd = {
        enable = mkOption {
          type = types.bool;
          default = pkgs.stdenv.hostPlatform.isx86_64 && config.myConfig.desktop.enable;
          description = "Enable libvirtd virtualization stack";
        };
        swtpm = mkOption {
          type = types.bool;
          default = false;
          description = "Enable Software TPM emulation for QEMU/KVM";
        };
      };
    };

    services = {
      attic = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable Attic binary cache substituter";
        };
      };

      openrgb = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable OpenRGB daemon for RGB controls";
        };
      };

      btrbk = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable BTRBK automated snapshot backup service";
        };
      };
    };
  };

  config = mkMerge [
    # --- CPU Microcode Options ---
    (mkIf (config.myConfig.hardware.cpu == "amd") {
      hardware.cpu.amd.updateMicrocode = true;
    })
    (mkIf (config.myConfig.hardware.cpu == "intel") {
      hardware.cpu.intel.updateMicrocode = true;
    })

    # --- GPU Profiles ---
    (mkIf (config.myConfig.hardware.gpu == "amd") {
      hardware = {
        amdgpu = {
          initrd.enable = true;
          overdrive.enable = true;
          opencl.enable = true;
        };
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
            rocmPackages.rocminfo
            rocmPackages.rocm-smi
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        amdgpu_top
        lact
        nvtopPackages.amd
        radeontop
        rocmPackages.rocm-smi
        rocmPackages.rocminfo
      ];
    })

    (mkIf (config.myConfig.hardware.gpu == "intel") {
      hardware = {
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            vaapi-intel-hybrid
            vpl-gpu-rt
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        intel-gpu-tools
        nvtopPackages.intel
      ];
    })

    # --- Laptop Power Profile ---
    (mkIf config.myConfig.hardware.power.enable {
      powerManagement.powertop.enable = mkDefault true;
      services = {
        thermald.enable = mkDefault true;
        power-profiles-daemon.enable = mkForce false;
        tlp = {
          enable = mkDefault true;
          pd.enable = mkDefault true;
          settings = mkDefault {
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
          settings = mkDefault {
            Login = {
              HandleLidSwitch = "suspend-then-hibernate";
              HandleLidSwitchExternalPower = "suspend";
              HandleLidSwitchDocked = "ignore";
            };
          };
        };
      };

      systemd.sleep.settings.Sleep = {
        HibernateDelaySec = mkDefault "5min";
      };
    })

    # --- Server Profile ---
    (mkIf (config.myConfig.role == "server") {
      documentation.enable = mkDefault false;
      services.openssh = {
        enable = mkDefault true;
        settings = {
          PermitRootLogin = mkDefault "no";
          PasswordAuthentication = mkDefault false;
        };
      };
    })
  ];
}
