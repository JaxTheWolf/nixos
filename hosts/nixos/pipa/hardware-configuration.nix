_: {
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-partlabel/linux_boot";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
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
    };

    "/home" = {
      device = "/dev/disk/by-partlabel/linux_root";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
    };
  };
}
