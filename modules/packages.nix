{
  config,
  pkgs,
  lib,
  czkawka-master,
  solaar-master,
  ...
}:

{
  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.10"
      ];
    };
    overlays = [
      (final: prev: {
        nautilus = prev.nautilus.overrideAttrs (nprev: {
          buildInputs =
            nprev.buildInputs
            ++ (with pkgs.gst_all_1; [
              gst-plugins-good
              gst-plugins-bad
              gst-plugins-ugly
              gst-plugins-base
            ]);
        });
      })
      (final: prev: {
        zenmonitor = prev.zenmonitor.overrideAttrs (oldAttrs: {
          env = (oldAttrs.env or { }) // {
            NIX_CFLAGS_COMPILE = "-std=gnu17";
          };
        });
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    abootimg
    amdgpu_top
    android-tools
    appstream
    arch-install-scripts
    aspell
    aspellDicts.cs
    aspellDicts.en
    aspellDicts.es
    bibata-cursors
    binwalk
    brscan4
    brscan5
    btrfs-progs
    bubblemail
    bzip2
    ccache
    curl
    # czkawka
    czkawka-master.packages.${pkgs.stdenv.hostPlatform.system}.default
    ddcutil
    discord
    distrobox
    docker-buildx
    docker-compose
    dog
    eza
    fahclient
    ffmpeg-full
    ffmpegthumbnailer
    file
    file-roller
    firmware-manager
    flat-remix-gnome
    flat-remix-gtk
    flatpak-xdg-utils
    freerdp
    fuse
    fuse3
    fwupd
    gimp
    gnome-tweaks
    gnome.gvfs
    gotop
    gparted
    gphoto2
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
    gvfs
    gzip
    htop
    i2c-tools
    iftop
    inkscape
    iotop
    jq
    killall
    kooha
    krita
    lact
    libgsf
    libnotify
    libreoffice
    libsForQt5.qtstyleplugins
    linux-firmware
    lm_sensors
    lrzip
    lsof
    lz4
    lzip
    lzop
    mangohud
    mesa-demos
    mission-center
    ncdu
    nil
    nixfmt-rfc-style
    ntfs3g
    nufraw-thumbnailer
    nvtopPackages.amd
    openrgb-with-all-plugins
    papirus-icon-theme
    pbzip2
    pciutils
    pigz
    plymouth
    poppler-utils
    prismlauncher-unwrapped
    protonup-qt
    radeontop
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    rquickshare
    saber
    # solaar
    solaar-master.packages.${pkgs.stdenv.hostPlatform.system}.default
    logitech-udev-rules
    scrcpy
    screen
    seafile-client
    smartmontools
    starship
    sushi
    swtpm
    telegram-desktop
    testdisk
    thunderbird
    tidal-hifi
    tldr
    tree
    unrar
    unzip
    usbutils
    ventoy-full-gtk
    vesktop
    vkbasalt
    vlc
    vscode-fhs
    webp-pixbuf-loader
    wev
    wget
    which
    wine
    wireshark
    tumbler
    xz
    yt-dlp
    zenmonitor
    zip
    zram-generator
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    zsh-syntax-highlighting
    zstd
    zulu
    zulu8
    zulu17
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
