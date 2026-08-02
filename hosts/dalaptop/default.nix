{pkgs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules/nm-dispatch-scripts.nix
  ];

  networking.hostName = "dalaptop";

  myConfig = {
    role = "laptop";
    hardware = {
      gpu = "intel";
      cpu = "intel";
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-power-manager
  ];

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true;
      accelProfile = "adaptive";
    };
  };

  systemd.services.disable-problematic-wakeup = {
    description = "Disable only specific noisy wakeup sources";
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'for device in XHC RP09 RP10 RP13; do if grep -q \"$device.*enabled\" /proc/acpi/wakeup; then echo $device > /proc/acpi/wakeup; fi; done'";
    };
  };
}
