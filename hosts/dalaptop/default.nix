_: {
  imports = [
    ../common
    ./hardware-configuration.nix
    ./modules
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  networking = {
    hostName = "dalaptop";
  };

  myConfig = {
    role = "laptop";
    hardware.gpu = "intel";
  };
}
