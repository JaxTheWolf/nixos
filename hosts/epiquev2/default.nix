_: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    loader = {
      systemd-boot = {};
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

  myConfig = {
    role = "workstation";
    hardware.gpu = "amd";
  };
}
