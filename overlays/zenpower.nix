_final: prev: let
  patchZenpower = _lfinal: lprev: {
    zenpower = lprev.zenpower.overrideAttrs (old: {
      makeFlags = (old.makeFlags or []) ++ lprev.kernel.commonMakeFlags;
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace Makefile \
            --replace-fail "-Wimplicit-fallthrough=3" "-Wimplicit-fallthrough"
        '';
    });
  };
in {
  linuxPackages_latest = prev.linuxPackages_latest.extend patchZenpower;

  cachyosKernels =
    prev.lib.mapAttrs (
      _: v:
        if v ? extend
        then v.extend patchZenpower
        else v
    )
    prev.cachyosKernels;
}
