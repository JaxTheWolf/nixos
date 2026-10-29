{inputs}: let
  nautilus = import ./nautilus.nix;
  zenpower = import ./zenpower.nix;
  cachyos-kernel = inputs.nix-cachyos-kernel.overlays.pinned;
  filefinder = inputs.filefinder.overlays.default;

  onlyX86 = overlay: final: prev:
    if prev.stdenv.hostPlatform.isx86_64
    then overlay final prev
    else {};
in {
  inherit cachyos-kernel nautilus filefinder zenpower;

  default = inputs.nixpkgs.lib.composeManyExtensions [
    (onlyX86 cachyos-kernel)
    filefinder
    nautilus
    (onlyX86 zenpower)
  ];
}
