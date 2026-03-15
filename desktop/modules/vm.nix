{ lib, ... }:
{
  virtualisation.vmVariant = {
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

    users.users.jax.password = "nixos";
    services.displayManager.autoLogin = {
      enable = true;
      user = "jax";
    };
  };
}
