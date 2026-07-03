final: prev: {
  pipa-firmware = final.callPackage ./firmware.nix {};
  pipa-kernel = final.callPackage ./kernel.nix {};
  pipa-headers = final.callPackage ./headers.nix {};
  qbootctl-pipa = final.callPackage ./qbootctl.nix {};
}
