final: prev: let
  pipaKernelVersion = "7.1.0";

  pipaKernelSrc = final.fetchFromGitHub {
    owner = "PipaDB";
    repo = "linux";
    rev = "e64607dc60963a05133304a8b682818ee4412106";
    hash = "sha256-3x5sCDfwzZ5A0NWJRw8mjX9FnxcA06UEcZkmf/QKJ9A=";
  };
in {
  pipa-firmware = final.callPackage ./firmware.nix {};

  pipa-kernel = final.callPackage ./kernel.nix {
    rawSrc = pipaKernelSrc;
    version = pipaKernelVersion;
  };

  pipa-headers = final.callPackage ./headers.nix {
    kernelSrc = pipaKernelSrc;
    version = pipaKernelVersion;
  };

  qbootctl-pipa = final.callPackage ./qbootctl.nix {};
}
