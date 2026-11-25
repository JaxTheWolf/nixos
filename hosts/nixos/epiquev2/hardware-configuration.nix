_: {
  boot = {
    initrd = {
      kernelModules = [];
    };

    kernelModules = [
      "kvm-amd"
      "nct6683"
    ];

    blacklistedKernelModules = ["k10temp"];

    kernelParams = [
      "rd.udev.log_priority=3"
      "video=HDMI-A-1:1504x1000@60"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/688ed267-cec9-400a-9226-32b0538eaecd";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/688ed267-cec9-400a-9226-32b0538eaecd";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/home/jax/.local/share/Steam" = {
      device = "/dev/disk/by-uuid/688ed267-cec9-400a-9226-32b0538eaecd";
      fsType = "btrfs";
      options = [
        "subvol=steam"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/688ed267-cec9-400a-9226-32b0538eaecd";
      fsType = "btrfs";
      options = [
        "subvol=@nix_nix"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/var" = {
      device = "/dev/disk/by-uuid/688ed267-cec9-400a-9226-32b0538eaecd";
      fsType = "btrfs";
      options = [
        "subvol=@nix_var"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3DB5-50DE";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/media/data" = {
      device = "/dev/disk/by-uuid/4c0c8b24-6fca-49c1-8e34-e00e240576e3";
      fsType = "btrfs";
      options = [
        "subvol=Data"
        "noatime"
        "compress=zstd:3"
        "nofail"
        "x-systemd.device-timeout=5s"
        "x-gvfs-trash"
      ];
    };

    "/media/games" = {
      device = "/dev/disk/by-uuid/4c0c8b24-6fca-49c1-8e34-e00e240576e3";
      fsType = "btrfs";
      options = [
        "subvol=Games"
        "noatime"
        "compress=zstd:3"
        "nofail"
        "x-systemd.device-timeout=5s"
        "x-gvfs-trash"
      ];
    };

    "/media/pipa" = {
      device = "/dev/disk/by-uuid/0013f713-acf4-496b-b43f-25258283b884";
      fsType = "f2fs";
      options = [
        "compress_algorithm=zstd:3"
        "compress_extension=*"
        "compress_chksum"
        "atgc"
        "gc_merge"
        "lazytime"
        "nofail"
        "x-systemd.device-timeout=5s"
      ];
    };

    "/media/spidy" = {
      device = "/dev/disk/by-uuid/c3cf1707-7fe0-4778-8142-5b950745b816";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd:3"
        "nofail"
        "x-systemd.device-timeout=5s"
      ];
    };

    "/media/hm-back" = {
      device = "/dev/disk/by-uuid/9d4951a7-5770-4a94-8847-03ab30ac6a33";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd:6"
        "nofail"
        "x-systemd.device-timeout=5s"
      ];
    };
  };

  swapDevices = [];
}
