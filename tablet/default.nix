{
  pkgs,
  lib,
  inputs,
  ...
}: let
  pipa-firmware = pkgs.callPackage ./pkgs/firmware.nix {};
in {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot.kernelPackages = let
    crossPkgs = import inputs.nixpkgs {
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
      config.allowUnfree = true;
    };
  in
    crossPkgs.linuxPackagesFor (crossPkgs.callPackage ./pkgs/kernel.nix {});

  hardware = {
    firmware = [
      pipa-firmware
    ];

    enableRedistributableFirmware = lib.mkDefault true;
    deviceTree.name = "qcom/sm8250-xiaomi-pipa.dtb";
  };

  networking = {
    hostName = "pipa";
  };

  environment.variables = {
    SYSTEMD_RELAX_ESP_CHECKS = "1";
  };

  security.sudo.extraConfig = ''
    Defaults env_keep += "SYSTEMD_RELAX_ESP_CHECKS"
  '';

  hardware.pipa.debugMode = false;
}
