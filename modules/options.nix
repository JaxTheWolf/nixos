{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options.myConfig = {
    role = mkOption {
      type = types.enum ["desktop" "laptop" "tablet" "server"];
      default = "desktop";
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
        type = types.enum ["none" "amd" "intel" "nvidia" "msm"];
        default = "none";
        description = "Hardware GPU acceleration profile";
      };

      cpu = mkOption {
        type = types.enum ["none" "amd" "intel" "msm"];
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

      battery = {
        enable = mkOption {
          type = types.bool;
          default = elem config.myConfig.role ["laptop" "tablet"];
          description = "Enable battery monitoring and power management tools";
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

    networking = {
      wgAutoToggle = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable automatic WireGuard tunnel toggle based on active network";
        };
        homeSsids = mkOption {
          type = types.listOf types.str;
          default = ["MERCUSYS_3C8A" "MERCUSYS_3C8A_5G"];
          description = "Home Wi-Fi SSIDs where WireGuard tunnels should be brought down";
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
  };
}
