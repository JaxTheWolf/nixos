{
  pkgs,
  lib,
  self,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;

  coreUtils = with pkgs; [
    curl
    file
    killall
    lsof
    ncdu
    pciutils
    tree
    usbutils
    wget
    which
  ];

  archiveTools = with pkgs; [
    bzip2
    file-roller
    gzip
    lrzip
    lz4
    lzip
    lzop
    pbzip2
    pigz
    unrar
    unzip
    xz
    zip
    zstd
  ];

  mediaAndThumbnails = with pkgs; [
    ffmpegthumbnailer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    libgsf
    nufraw-thumbnailer
    poppler-utils
    pulseaudio
    sushi
    tumbler
    webp-pixbuf-loader
  ];

  systemAdminAndHardware = with pkgs; [
    appstream
    aspell
    aspellDicts.cs
    aspellDicts.en
    aspellDicts.es
    attic-client
    btrfs-progs
    ddcutil
    distrobox
    docker-buildx
    docker-compose
    flatpak-xdg-utils
    fuse
    fuse3
    gparted
    gphoto2
    i2c-tools
    iftop
    iotop
    linux-firmware
    lm_sensors
    logitech-udev-rules
    networkmanager-openconnect
    ntfs3g
    smartmontools
  ];

  desktopAndTheming = with pkgs; [
    bibata-cursors
    flat-remix-gnome
    flat-remix-gtk
    gnome-tweaks
    gnome.gvfs
    gvfs
    libnotify
    libsForQt5.qtstyleplugins
    papirus-icon-theme
    seafile-client
    solaar
    wev
  ];

  x86Packages = with pkgs; [
    abootimg
    android-tools
    brscan4
    brscan5
    ffmpeg-full
    graalvmPackages.graalvm-oracle_25
    plymouth
    ventoy-full-gtk
    zulu
    zulu8
  ];
in {
  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.12"
        "cisco-packet-tracer_9"
      ];
    };

    overlays = [
      self.overlays.nautilus
    ];
  };

  environment.systemPackages =
    coreUtils
    ++ archiveTools
    ++ mediaAndThumbnails
    ++ systemAdminAndHardware
    ++ desktopAndTheming
    ++ lib.optionals isx86 x86Packages;

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
