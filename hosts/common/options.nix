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

    desktop = {
      gnome.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable GNOME desktop environment";
      };

      flatpak.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Flatpak package manager";
      };
    };

    hardware = {
      gpu = mkOption {
        type = types.enum ["none" "amd" "intel"];
        default = "none";
        description = "Hardware GPU acceleration profile";
      };
    };
  };

  config = mkMerge [
    (mkIf (config.myConfig.hardware.gpu == "amd") {
      hardware = {
        cpu.amd.updateMicrocode = true;
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
        cpu.intel.updateMicrocode = true;
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

    (mkIf (config.myConfig.role == "server") {
      myConfig.desktop.gnome.enable = mkDefault false;
      myConfig.desktop.flatpak.enable = mkDefault false;

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
