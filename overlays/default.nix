{inputs}: let
  cachyos-kernel = inputs.nix-cachyos-kernel.overlays.pinned;
  nautilus = import ./nautilus.nix;
  filefinder = inputs.filefinder.overlays.default;
in {
  inherit cachyos-kernel nautilus filefinder;

  default = inputs.nixpkgs.lib.composeManyExtensions [
    cachyos-kernel
    filefinder
    nautilus
  ];
}
