{
  pkgs,
  ...
}:

{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

    kernelModules = [
      "hid-logitech-dj"
      "hid-logitech-hidpp"
    ];
  };
}
