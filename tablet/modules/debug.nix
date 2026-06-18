{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hardware.pipa.debugMode = lib.mkEnableOption "USB Ethernet and Serial Debugging via ttyGS0";

  config = lib.mkIf config.hardware.pipa.debugMode {
    users.users.nixos = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDOwnOKjUpX6gFdSeNkDEETezAhPtHgVfFO0GO44YeD7 roman.lubij@gmail.com"
      ];
    };
  };
}
