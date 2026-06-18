{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      btop
      curl
      killall
      lm_sensors
      ncdu
      ntfs3g
      pciutils
      unrar
      unzip
      usbutils
      wget
      file
      which
      which
      zip
      zram-generator
      zstd
      gnome-power-manager
    ];

    gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      geary
      gnome-connections
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      gnome-software
      gnome-system-monitor
      showtime
      snapshot
      totem
      yelp
    ];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
