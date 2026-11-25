_: {
  boot = {
    initrd = {
      kernelModules = [];
    };

    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    resumeDevice = "/dev/disk/by-uuid/bea07563-dc23-415b-b12f-ba53138bd492";

    kernelParams = [
      "snd_hda_intel.power_save=1"
      "mem_sleep_default=deep"
      "pcie_aspm=force"
      "i915.enable_guc=3"
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
      "i915.fastboot=1"
      "i915.enable_dc=1"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7b31f189-b34a-4cf0-95c5-bbcd6830159e";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/7b31f189-b34a-4cf0-95c5-bbcd6830159e";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/7b31f189-b34a-4cf0-95c5-bbcd6830159e";
      fsType = "btrfs";
      options = [
        "subvol=@nix_nix"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/var" = {
      device = "/dev/disk/by-uuid/7b31f189-b34a-4cf0-95c5-bbcd6830159e";
      fsType = "btrfs";
      options = [
        "subvol=@nix_var"
        "noatime"
        "compress=zstd:3"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/477C-4D52";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/bea07563-dc23-415b-b12f-ba53138bd492";
      priority = 0;
      options = [
        "discard=once"
      ];
    }
  ];
}
