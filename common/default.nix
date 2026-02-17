{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./modules
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
      };
    };
    consoleLogLevel = 3;
    plymouth.enable = true;
  };

  networking = {
    networkmanager.enable = true;
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
      extraConfig = ''
        unix_sock_group = "qemu-libvirtd"
      '';
      
      onBoot = "ignore";
    };
    spiceUSBRedirection.enable = true;
  };

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
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    warn-dirty = false;
  };

  system.stateVersion = "25.05";
}
