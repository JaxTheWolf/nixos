{
  pkgs,
  lib,
  ...
}: let
  setOpenRgbProfile = import ./openrgb-init.nix {inherit pkgs lib;};
  inherit (setOpenRgbProfile) orgbScript;
in {
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

  powerManagement.resumeCommands = "${orgbScript}";

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
        snapshot_create = "onchange";

        volume."/" = {
          snapshot_dir = "home/.snapshots";

          subvolume."home" = {
            target."/media/home-backup" = {
              target_preserve = "0d 10w 8m 0y";
            };
          };

          subvolume."home/jax/.local/share/Steam" = {
            snapshot_preserve = "3d";
            stream_compress = "zstd";

            target."/media/home-backup/steam" = {
              target_preserve = "0d 4w 1m";
            };
          };
        };
      };
    };
  };
}
