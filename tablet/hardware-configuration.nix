{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./modules/debug.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    initrd = {
      availableKernelModules = [
        "panel_novatek_nt36532"
        "msm"
        "nanosic_803"
        "usbhid"
        "pinctrl_sm8250"
        "ufs_qcom"
        "ufshcd_core"
        "ufshcd_pltfrm"
        "icc_osm_l3"
        "phy_qcom_qmp_ufs"
        "phy_qcom_qmp_pcie"
      ];

      kernelModules = [];

      extraFirmwarePaths = [
        "novatek/nt36532_tianma.bin"
        "novatek/nt36532_csot.bin"
        "qcom/a650_sqe.fw"
        "qcom/a650_gmu.bin"
        "qcom/a650_zap.mbn"
      ];
    };

    kernelParams = [
      "console=tty0"
      "fbcon=rotate:1"
      "rootwait"
    ];

    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIX_BOOT";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/" = {
      device = "/dev/disk/by-label/NIX_ROOT";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIX_ROOT";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-label/NIX_ROOT";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
}
