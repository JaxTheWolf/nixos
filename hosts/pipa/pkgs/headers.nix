{
  stdenv,
  perl,
  rsync,
  kernelSrc,
  version,
}:
stdenv.mkDerivation {
  inherit version;
  pname = "linux-headers-pipa";
  src = kernelSrc;

  nativeBuildInputs = [perl rsync];

  dontConfigure = true;

  buildPhase = ''
    make headers_install ARCH=arm64 INSTALL_HDR_PATH=$out
  '';

  dontInstall = true;

  dontFixup = true;

  meta = {
    description = "Kernel headers for pipa kernel";
    platforms = ["aarch64-linux"];
  };
}
