{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  imports = [
    ./modules
    ./hardware-configuration.nix
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  nixpkgs.overlays = [inputs.filefinder.overlays.default];
  nixpkgs.config.allowUnfree = true;

  virtualisation.vmVariant = {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      users.jax = {
        imports = [
          ./modules/home
        ];
      };
    };
  };

  documentation.nixos.enable = false;

  boot = lib.mkIf isx86 {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
    };

    binfmt = {
      registrations.aarch64-linux = {
        interpreter = "${pkgs.pkgsStatic.qemu-user}/bin/qemu-aarch64";
        fixBinary = true;
        matchCredentials = true;
        wrapInterpreterInShell = false;
        magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
        mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\x00\xfe\xff\xff\xff'';
      };
    };

    consoleLogLevel = 3;
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
  };

  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
    };

    firewall.enable = false;
  };

  time.timeZone = "Europe/Prague";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "cs_CZ.UTF-8";
      LC_IDENTIFICATION = "cs_CZ.UTF-8";
      LC_MEASUREMENT = "cs_CZ.UTF-8";
      LC_MONETARY = "cs_CZ.UTF-8";
      LC_NAME = "cs_CZ.UTF-8";
      LC_NUMERIC = "cs_CZ.UTF-8";
      LC_PAPER = "cs_CZ.UTF-8";
      LC_TELEPHONE = "cs_CZ.UTF-8";
      LC_TIME = "cs_CZ.UTF-8";
    };
  };

  console = {
    keyMap = "cz-lat2";
    font = "Lat2-Terminus16";
  };

  xdg.portal.enable = true;

  security = {
    rtkit.enable = true;
    sudo.extraConfig = ''
      Defaults insults
    '';

    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.libvirt.unix.manage" &&
              subject.isInGroup("qemu-libvirtd")) {
              return polkit.Result.YES;
          }
      });
    '';
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = false;
      storageDriver = "btrfs";
      enableOnBoot = true;
    };

    libvirtd = lib.mkIf isx86 {
      enable = true;
      extraConfig = ''
        unix_sock_group = "qemu-libvirtd"
      '';

      onBoot = "ignore";
    };

    spiceUSBRedirection.enable = isx86;
  };

  users.users.jax = {
    isNormalUser = true;
    description = "Roman Lubij";
    extraGroups =
      [
        "networkmanager"
        "wheel"
        "docker"
        "qemu-libvirtd"
        "camera"
        "video"
        "render"
        "input"
        "dialout"
      ]
      ++ lib.optional config.programs.wireshark.enable "wireshark";

    shell = pkgs.zsh;
    #packages = with pkgs; [ ];
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };

    systemPackages = with pkgs; [
      libheif
      libheif.out
    ];

    pathsToLink = ["share/thumbnailers"];
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez.overrideAttrs (old: {
        configureFlags =
          old.configureFlags
          ++ [
            "--enable-sixaxis"
          ];
      });

      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
      settings = {
        General = {
          Experimental = true;
          Name = config.networking.hostName;
        };
      };
    };

    i2c.enable = true;
    graphics = {
      enable = true;
      package = pkgs.mesa;
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  qt = {
    platformTheme = "qt5ct";
    style = "adwaita-dark";
    enable = true;
  };

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];

    auto-optimise-store = true;
    extra-platforms = ["aarch64-linux" "i686-linux"];
    warn-dirty = false;
  };

  system.stateVersion = "25.05";
}
