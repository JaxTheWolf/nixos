{pkgs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "epiquev2";

  myConfig = {
    role = "desktop";
    hardware = {
      gpu = "amd";
      cpu = "amd";
    };
    virtualisation.libvirtd = {
      enable = true;
      swtpm = true;
    };
  };

  boot.tmp.useTmpfs = true;

  environment = {
    systemPackages = with pkgs; [
      arch-install-scripts
      fahclient
      zenmonitor
      gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
    ];

    etc."xdg/monitors.xml" = {
      source = ./monitors.xml;
      mode = "0644";
      user = "root";
      group = "root";
    };
  };

  services = {
    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
      package = pkgs.openrgb-with-all-plugins;
    };

    udev.extraRules = ''
      SUBSYSTEM=="block", ENV{ID_FS_UUID}=="39c48cb1-233c-4921-a614-3a193574df67", ENV{UDISKS_IGNORE}="1"
    '';

    btrbk.instances.home_backups = {
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
}
