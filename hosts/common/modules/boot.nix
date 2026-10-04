{
  pkgs,
  lib,
  config,
  ...
}: let
  isx86 = pkgs.stdenv.hostPlatform.isx86_64;
in {
  boot = {
    initrd = {
      systemd.enable = true;
      kernelModules =
        lib.optionals (config.myConfig.hardware.gpu == "amd") ["amdgpu"]
        ++ lib.optionals (config.myConfig.hardware.gpu == "intel") ["i915"];
    };

    kernelParams =
      [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "vt.global_cursor_default=0"
      ]
      ++ lib.optionals (config.myConfig.hardware.gpu == "amd") [
        "amdgpu.seamless=1"
      ];

    loader = {
      efi.canTouchEfiVariables = isx86;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 10;
        memtest86.enable = isx86;
      };
    };

    binfmt = lib.mkIf isx86 {
      registrations.aarch64-linux = {
        interpreter = "${pkgs.pkgsStatic.qemu-user}/bin/qemu-aarch64";
        fixBinary = true;
        matchCredentials = true;
        wrapInterpreterInShell = false;
        magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00'';
        mask = ''\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\x00\xfe\xff\xff\xff'';
      };
    };

    plymouth = {
      enable = true;
      theme = "solar";
    };

    consoleLogLevel = 3;
    tmp.cleanOnBoot = true;
  };
}
