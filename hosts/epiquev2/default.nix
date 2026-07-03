{pkgs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    loader = {
      systemd-boot = {
        # windows = {
        #   "w" = {
        #     title = "Windows";
        #     efiDeviceHandle = "HD3b";
        #   };
        # };
      };
    };
    tmp.useTmpfs = true;
  };

  networking = {
    hostName = "epiquev2";
  };

  virtualisation = {
    libvirtd = {
      qemu = {
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  hardware = {
    cpu.amd.updateMicrocode = true;

    amdgpu = {
      initrd.enable = true;
      overdrive.enable = true;
    };

    graphics = {
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        rocmPackages.rocminfo
        rocmPackages.rocm-smi
      ];
    };

    amdgpu.opencl.enable = true;
  };
}
