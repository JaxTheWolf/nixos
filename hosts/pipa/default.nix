{
  pkgs,
  lib,
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
