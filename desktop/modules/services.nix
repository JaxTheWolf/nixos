{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    zram-generator
  ];

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
      daily_ssd = {
        onCalendar = "daily";
        settings = {
          timestamp_format = "long";
          snapshot_preserve = "7d";

          volume."/" = {
            subvolume = "home";
            snapshot_dir = "home/.snapshots/daily";
          };
        };
      };

      weekly_hdd = {
        onCalendar = "weekly";
        settings = {
          timestamp_format = "long";
          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";
          target_preserve = "20w";

          volume."/" = {
            subvolume = "home";
            snapshot_dir = "home/.snapshots/weekly";
            target = "/media/home-backup";
          };
        };
      };
    };
  };
}
