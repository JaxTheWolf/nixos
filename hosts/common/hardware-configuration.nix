_: {
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

    kernelModules = [
      "hid-logitech-dj"
      "hid-logitech-hidpp"
    ];
  };
}
