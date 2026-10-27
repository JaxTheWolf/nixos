{inputs}: let
  nautilus = import ./nautilus.nix;
  zenpower = import ./zenpower.nix;
  cachyos-kernel = inputs.nix-cachyos-kernel.overlays.pinned;
  filefinder = inputs.filefinder.overlays.default;
in {
  inherit cachyos-kernel nautilus filefinder zenpower;

  default = inputs.nixpkgs.lib.composeManyExtensions [
    cachyos-kernel
    filefinder
    nautilus
    zenpower
  ];
}
