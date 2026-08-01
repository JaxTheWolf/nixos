{
  pkgs,
  lib,
  inputs,
  self ? inputs.self,
  config,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ./modules
    ./hardware-configuration.nix
  ];

  stylix =
    (import ./theming-shared.nix {inherit pkgs;})
    // {
      targets = {
        nixos-icons.enable = false;
        plymouth.enable = false;
      };
    };

  nixpkgs = {
    overlays = [inputs.filefinder.overlays.default];
    config.allowUnfree = true;
  };

  virtualisation.vmVariant = {
    imports = [inputs.home-manager.nixosModules.home-manager];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs self;
        osConfig = config;
      };
      users.jax = {
        imports =
          [
            ./modules/home
          ]
          ++ lib.optionals config.myConfig.desktop.enable [
            ./modules/home/gui
          ]
          ++ lib.optionals (builtins.pathExists (./. + "/../${config.networking.hostName}/home.nix")) [
            (./. + "/../${config.networking.hostName}/home.nix")
          ];
      };
    };

    swapDevices = lib.mkForce [];
    boot.resumeDevice = lib.mkForce "";

    users.users.jax.password = "nixos";
    services.displayManager.autoLogin = {
      enable = true;
      user = "jax";
    };

    virtualisation = {
      memorySize = 8192;
      cores = 4;
      graphics = true;
      diskSize = 20 * 1024;
      qemu.options = [
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
        "-cpu host"
      ];
    };
  };

  documentation.nixos.enable = false;

  boot = lib.mkIf isx86 {
    initrd.kernelModules =
      lib.optionals (config.myConfig.hardware.gpu == "amd") ["amdgpu"]
      ++ lib.optionals (config.myConfig.hardware.gpu == "intel") ["i915"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
        consoleMode = "max";
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
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
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

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = ["gnome" "gtk"];
  };

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
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      GTK_USE_PORTAL = "1";
      QT_USE_PORTAL = "1";
    };

    systemPackages = with pkgs; [
      libheif
      libheif.out
    ];

    pathsToLink = ["share/thumbnailers"];
  };

  hardware = {
    enableRedistributableFirmware = true;

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
