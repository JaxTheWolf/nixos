{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-partlabel/linux_boot";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/" = {
      device = "/dev/disk/by-partlabel/linux_root";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-partlabel/linux_root";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/disk/by-partlabel/linux_root";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };
  };
}
