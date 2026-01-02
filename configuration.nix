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
    ./modules/flatpak.nix
    ./modules/gdm-monitors.nix
    ./modules/gnome.nix
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/services.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        windows = {
          "w" = {
            title = "Windows";
            efiDeviceHandle = "HD3b";
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
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = false;
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
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
      extraConfig = ''
        unix_sock_group = "qemu-libvirtd"
      '';
      onBoot = "ignore";
    };
    spiceUSBRedirection.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jax = {
    isNormalUser = true;
    description = "Roman Lubij";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "qemu-libvirtd"
      "camera"
      "video"
      "render"
      "input"
    ];
    shell = pkgs.zsh;
    #packages = with pkgs; [ ];
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
    systemPackages = [
      pkgs.libheif
      pkgs.libheif.out
    ];
    pathsToLink = [ "share/thumbnailers" ];
  };

  hardware = {
    amdgpu = {
      initrd.enable = true;
      overdrive.enable = true;
    };
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
      extraPackages = with pkgs; [
        rocmPackages.clr.icd # The ROCm OpenCL ICD
        rocmPackages.rocminfo # The utility you want to run
        rocmPackages.rocm-smi # Useful for general GPU health checks
      ];
    };
    amdgpu.opencl.enable = true; # ROCM
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  # QT stuff
  qt = {
    platformTheme = "qt5ct";
    style = "adwaita-dark";
    enable = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    warn-dirty = false;
  };

  system.stateVersion = "25.05";
}
