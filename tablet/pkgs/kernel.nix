{
  lib,
  buildLinux,
  fetchFromGitea,
  fetchFromGitHub,
  runCommand,
  ...
} @ args: let
  rawSrc = fetchFromGitHub {
    owner = "PipaDB";
    repo = "linux";
    rev = "dba2f27e87cfa398cc5e5eb76e4beac30c2ecc71";
    hash = "sha256-OAgEjxbv8nY5VLW+mlnh0GeZDC6yHH7MF2sEgcMu9NE=";
  };

  patchedSrc = runCommand "linux-src-pipa" {} ''
    cp -a ${rawSrc} $out
    chmod -R +w $out

    cp ${./pipa.config} $out/arch/arm64/configs/pipa.config
    patchShebangs $out
  '';
in
  buildLinux (args
    // {
      version = "7.0.8";
      modDirVersion = "7.0.8";
      src = patchedSrc;
      defconfig = "pipa.config";
      ignoreConfigErrors = true;
      enableCommonConfig = false;
      stripDebugList = ["vmlinux" "lib/modules"];

      structuredExtraConfig = with lib.kernel; {
        DRM_AMDGPU = no;
        DRM_NOUVEAU = no;
        DRM_RADEON = no;
        DRM_I915 = no;
        INFINIBAND = no;
        INFINIBAND_USER_ACCESS = no;
        FPGA = no;
        THUNDERBOLT = no;
        COMEDI = no;
        GNSS = no;
        MOST = no;
        RUNTIME_TESTING_MENU = no;
      };

      extraMeta.branch = "7.0";
    })
