{
  stdenv,
  fetchFromGitHub,
  perl,
  rsync,
}:
stdenv.mkDerivation {
  pname = "linux-headers-pipa";
  version = "7.0.8";

  src = fetchFromGitHub {
    owner = "PipaDB";
    repo = "linux";
    rev = "dba2f27e87cfa398cc5e5eb76e4beac30c2ecc71";
    hash = "sha256-OAgEjxbv8nY5VLW+mlnh0GeZDC6yHH7MF2sEgcMu9NE=";
  };

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
