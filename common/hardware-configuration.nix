{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "uas"
        "usbhid"
        "sd_mod"
      ];
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    kernelModules = [
      "hid-logitech-dj"
      "hid-logitech-hidpp"
    ];
  };
}
