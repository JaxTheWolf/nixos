# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/gdm-monitors.nix
    ./modules/programs.nix
  ];

  boot = {
    initrd.kernelModules = [ ];
    initrd.verbose = false;
    kernelModules = [ "nct6683" ];
    blacklistedKernelModules = [ "k10temp" ];
    kernelParams = [
      "amdgpu.seamless=1"
      "rd.udev.log_priority=3"
      "vt.global_cursor_default=0"
    ];
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    extraModulePackages = with config.boot.kernelPackages; [
      pkgs.linuxKernel.packages.linux_xanmod_latest.zenpower
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        windows = {
          "w" = {
            title = "Windows";
            efiDeviceHandle = "HD(1,GPT,ee23cd4d-b501-4b9d-9ca0-971fa6be44cf,0x800,0x32000)"; # ?????????
          };
        };
      };
    };
    consoleLogLevel = 3;
    plymouth.enable = true;
  };

  networking = {
    hostName = "epiquev2";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.

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

  # Configure console keymap
  console.keyMap = "cz-lat2";

  xdg.portal.enable = true;

  security.rtkit.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
      storageDriver = "btrfs";
      enableOnBoot = true;
    };
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;

    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jax = {
    isNormalUser = true;
    description = "Roman Lubij";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
    ];
    shell = pkgs.zsh;
    #packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "ventoy-gtk3-1.1.07"
    ];
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
  };

  hardware = {
    amdgpu.initrd.enable = true;
    amdgpu.overdrive.enable = true;
    bluetooth = {
      enable = true;
      package = pkgs.bluez.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [
          "--enable-sixaxis"
        ];
      });
      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
      settings = {
        General = {
          # FastConnectable = true;
          Name = "epiquev2";
          Experimental = true;
        };
      };
    };
    i2c.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs.mesa;
    };
    # amdgpu.opencl.enable = true; ROCM
  };

  # QT stuff
  qt = {
    style = "gtk2";
    platformTheme = "qt5ct";
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    warn-dirty = false;
    substituters = [
      "https://nyx.chaotic.cx"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:Z94nz89Kd721HGLrYPYiWnL3izUZoofuA+3ykIbE+Bs="
      "cache.nixos.org-1:6NCHdD59MDW/s82/h4RZcnxaz2bYcxoZb0qwYf5ED+w="
    ];
  };

  system.stateVersion = "25.05";
}
