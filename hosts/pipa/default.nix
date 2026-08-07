_: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs.overlays = [
    (import ./pkgs)
  ];

  networking.hostName = "pipa";

  myConfig = {
    role = "tablet";
  };

  boot = {
    plymouth = {
      enable = true;
      logo = ./logo.png;
    };
  };

  environment.variables = {
    SYSTEMD_RELAX_ESP_CHECKS = "1";
  };

  security.sudo.extraConfig = ''
    Defaults env_keep += "SYSTEMD_RELAX_ESP_CHECKS"
  '';
}
