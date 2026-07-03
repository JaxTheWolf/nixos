{pkgs, ...}: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking = {
    hostName = "dalaptop";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    graphics = {
      extraPackages = with pkgs; [
        vaapi-intel-hybrid
        vpl-gpu-rt
      ];
    };
  };
}
