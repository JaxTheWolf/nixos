{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  home-manager.users.jax.imports = [./modules/home];

  networking = {
    hostName = "dalaptop";
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    bluetooth = {
      settings = {
        General = {
          Name = "dalaptop";
        };
      };
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapi-intel-hybrid
        vpl-gpu-rt
      ];
    };
  };
}
