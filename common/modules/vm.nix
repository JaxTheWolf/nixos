{
  lib,
  ...
}:

{
  virtualisation.vmVariant = {
    virtualisation.memorySize = 8192;

    virtualisation.cores = 4;
    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display gtk,gl=on"
      "-cpu host"
    ];

    users.users.jax.password = "nixos";
    services.displayManager.autoLogin = {
      enable = true;
      user = "jax";
    };
  };
}
