{pkgs, ...}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.12"
        "cisco-packet-tracer_9"
      ];
    };

    overlays = [
      (final: prev: {
        nautilus = prev.nautilus.overrideAttrs (nprev: {
          buildInputs =
            nprev.buildInputs
            ++ (with pkgs.gst_all_1; [
              gst-plugins-bad
              gst-plugins-base
              gst-plugins-good
              gst-plugins-ugly
            ]);
        });
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    abootimg
    android-tools
    appstream
    aspell
    aspellDicts.cs
    aspellDicts.en
    aspellDicts.es
    attic-client
    bibata-cursors
    brscan4
    brscan5
    btrfs-progs
    bzip2
    curl
    ddcutil
    distrobox
    docker-buildx
    docker-compose
    ffmpeg-full
    ffmpegthumbnailer
    file
    file-roller
    flat-remix-gnome
    flat-remix-gtk
    flatpak-xdg-utils
    freerdp
    fuse
    fuse3
    fwupd
    gnome-tweaks
    gnome.gvfs
    gparted
    gphoto2
    graalvmPackages.graalvm-oracle_25
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    gvfs
    gzip
    i2c-tools
    iftop
    iotop
    killall
    libgsf
    libnotify
    libsForQt5.qtstyleplugins
    linux-firmware
    lm_sensors
    logitech-udev-rules
    lrzip
    lsof
    lz4
    lzip
    lzop
    mangohud
    mesa-demos
    mission-center
    ncdu
    networkmanager-openconnect
    ntfs3g
    nufraw-thumbnailer
    papirus-icon-theme
    pbzip2
    pciutils
    pigz
    plymouth
    poppler-utils
    prismlauncher
    protonup-qt
    pulseaudio
    screen
    seafile-client
    smartmontools
    solaar
    sushi
    tree
    tumbler
    unrar
    unzip
    usbutils
    ventoy-full-gtk
    vkbasalt
    webp-pixbuf-loader
    wev
    wget
    which
    wineWow64Packages.waylandFull
    wireshark
    xz
    zip
    zram-generator
    zstd
    zulu
    zulu17
    zulu8
  ];

  fonts = {
    packages = with pkgs; [
      fira-code
      font-awesome
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.symbols-only
      nerd-fonts.ubuntu-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      ubuntu-classic
    ];
  };
}
