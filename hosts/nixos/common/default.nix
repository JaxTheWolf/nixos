{
  pkgs,
  lib,
  inputs,
  self ? inputs.self,
  config,
  ...
}: let
  user = config.myConfig.user;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.nix-flatpak.nixosModules.nix-flatpak
    ../../../modules
    ./hardware-configuration.nix
  ];

  stylix =
    (import ../../../theming {inherit pkgs;})
    // {
      targets = {
        plymouth.enable = false;
      };
    };

  documentation.nixos.enable = false;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config.common.default = ["gnome" "gtk"];
  };

  users.users.${user.name} = {
    isNormalUser = true;
    inherit (user) description;
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
      GTK_USE_PORTAL = "1";
      QT_USE_PORTAL = "1";
    };

    systemPackages = with pkgs; [
      libheif
      libheif.out
    ];

    pathsToLink = ["share/thumbnailers"];
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
      users.${user.name} = {
        imports =
          [
            ../../../home
          ]
          ++ lib.optionals config.myConfig.desktop.enable [
            ../../../home/gui
          ]
          ++ lib.optionals (builtins.pathExists (../${config.networking.hostName}/home.nix)) [
            (../${config.networking.hostName}/home.nix)
          ];
      };
    };

    swapDevices = lib.mkForce [];
    boot.resumeDevice = lib.mkForce "";

    users.users.${user.name}.password = "nixos";
    services.displayManager.autoLogin = {
      enable = true;
      user = user.name;
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

  system.stateVersion = "25.05";
}
