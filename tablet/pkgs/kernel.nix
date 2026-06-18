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
      defconfig = "defconfig pipa.config";
      ignoreConfigErrors = true;
      stripDebugList = ["vmlinux" "lib/modules"];

      extraMeta.branch = "7.0";
    })
