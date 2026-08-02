{pkgs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  myConfig = {
    role = "workstation";
    hardware = {
      gpu = "amd";
      cpu = "amd";
    };
    virtualisation = {
      libvirtd = {
        enable = true;
        swtpm = true;
      };
    };
    services = {
      openrgb.enable = true;
      btrbk.enable = true;
    };
  };

  boot = {
    loader.systemd-boot = {};
    tmp.useTmpfs = true;
  };

  networking.hostName = "epiquev2";

  environment.systemPackages = with pkgs; [
    arch-install-scripts
    fahclient
    swtpm
    zenmonitor
    gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
  ];

  virtualisation = {
    spiceUSBRedirection.enable = true;
  };

  services = {
    lact.enable = true;

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
      package = pkgs.openrgb-with-all-plugins;
    };

    udev.extraRules = ''
      SUBSYSTEM=="block", ENV{ID_FS_UUID}=="39c48cb1-233c-4921-a614-3a193574df67", ENV{UDISKS_IGNORE}="1"
    '';

    btrbk.instances = {
      home_backups = {
        onCalendar = "daily";
        settings = {
          timestamp_format = "long";

          snapshot_preserve_min = "latest";
          snapshot_preserve = "7d";

          volume."/" = {
            snapshot_dir = "home/.snapshots";

            subvolume."home" = {
              target."/media/home-backup" = {
                target_preserve = "0d 20w 0m";
              };
            };
          };
        };
      };
    };
  };
}
