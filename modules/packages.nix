{
  pkgs,
  lib,
  config,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
  isDesktop = config.myConfig.desktop.enable or false;

  coreUtils = with pkgs; [
    curl
    dig
    file
    iperf3
    killall
    lsof
    ncdu
    nmap
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
    btrfs-progs
    ddcutil
    distrobox
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
    ntfs3g
    plymouth
    smartmontools
  ];

  desktop = with pkgs; [
    gvfs
    libnotify
    wev
    wl-clipboard
  ];

  x86Packages = with pkgs;
    [
      abootimg
      android-tools
      brscan4
      brscan5
      ffmpeg-full
      graalvmPackages.graalvm-oracle_25
      zulu
      zulu8
    ]
    ++ lib.optionals isDesktop [
      ventoy-full-gtk
    ];
in {
  environment.systemPackages =
    coreUtils
    ++ archiveTools
    ++ lib.optionals isDesktop (mediaAndThumbnails ++ desktop)
    ++ systemAdminAndHardware
    ++ lib.optionals isx86 x86Packages;

  fonts = lib.mkIf isDesktop {
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
