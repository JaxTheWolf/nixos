{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
    ../common
  ];

  boot = {
    loader = {
      systemd-boot = {
        windows = {
          "w" = {
            title = "Windows";
            efiDeviceHandle = "HD3b";
          };
        };
      };
    };
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

    bluetooth = {
      settings = {
        General = {
          Name = "epiquev2";
        };
      };
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
