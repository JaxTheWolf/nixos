{inputs}: let
  nautilus = import ./nautilus.nix;
  filefinder = inputs.filefinder.overlays.default;
in {
  inherit nautilus filefinder;

  default = inputs.nixpkgs.lib.composeManyExtensions [
    filefinder
    nautilus
  ];
}
