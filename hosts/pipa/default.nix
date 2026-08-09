{inputs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    inputs.pipa-nixos.nixosModules.default
  ];

  networking.hostName = "pipa";

  myConfig = {
    role = "tablet";
    hardware = {
      cpu = "msm";
      gpu = "msm";
    };
  };
}

