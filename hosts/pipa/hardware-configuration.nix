{
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

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
}

