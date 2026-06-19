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
  '';
in
  buildLinux (args
    // {
      version = "7.0.8";
      modDirVersion = "7.0.8";
      src = patchedSrc;
      defconfig = "pipa.config";
      ignoreConfigErrors = true;
      stripDebugList = ["vmlinux" "lib/modules"];

      structuredExtraConfig = with lib.kernel; {
        DRM_AMDGPU = lib.mkForce no;
        DRM_NOUVEAU = lib.mkForce no;
        DRM_RADEON = lib.mkForce no;
        DRM_I915 = lib.mkForce no;
        INFINIBAND = lib.mkForce no;
        INFINIBAND_USER_ACCESS = lib.mkForce no;
        FPGA = lib.mkForce no;
        THUNDERBOLT = lib.mkForce no;
        COMEDI = lib.mkForce no;
        GNSS = lib.mkForce no;
        MOST = lib.mkForce no;
      };

      extraMeta.branch = "7.0";
    })
