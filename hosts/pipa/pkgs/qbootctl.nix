{
  qbootctl,
  pipa-headers,
}:
qbootctl.overrideAttrs (old: {
  pname = "qbootctl-pipa";

  NIX_CFLAGS_COMPILE = "-isystem ${pipa-headers}/include " + (old.NIX_CFLAGS_COMPILE or "");
})
