_: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    overlays = [
      (import ./pkgs)
    ];
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
}
