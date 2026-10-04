{
  pkgs,
  lib,
  config,
  ...
}: let
  hw = config.myConfig.hardware;
in {
  # --- Hardware Foundations ---
  hardware = {
    enableRedistributableFirmware = true;
    i2c.enable = true;

    cpu = {
      amd.updateMicrocode = lib.mkIf (hw.cpu == "amd") true;
      intel.updateMicrocode = lib.mkIf (hw.cpu == "intel") true;
    };

    graphics = {
      enable = true;
      package = pkgs.mesa;
      extraPackages =
        lib.optionals (hw.gpu == "amd") [
          pkgs.rocmPackages.clr.icd
          pkgs.rocmPackages.rocminfo
          pkgs.rocmPackages.rocm-smi
        ]
        ++ lib.optionals (hw.gpu == "intel") [
          pkgs.vaapi-intel-hybrid
          pkgs.vpl-gpu-rt
        ];
    };

    amdgpu = lib.mkIf (hw.gpu == "amd") {
      initrd.enable = true;
      overdrive.enable = true;
      opencl.enable = true;
    };

    bluetooth = lib.mkIf hw.bluetooth.enable {
      enable = true;
      package = pkgs.bluez.overrideAttrs (old: {
        configureFlags =
          old.configureFlags
          ++ [
            "--enable-sixaxis"
          ];
      });

      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
      settings.General = {
        Experimental = true;
        Name = config.networking.hostName;
      };
    };

    logitech.wireless.enable = lib.mkIf hw.logitech.enable true;
  };

  # --- Kernel Modules ---
  boot.kernelModules = lib.optionals hw.logitech.enable [
    "hid-logitech-dj"
    "hid-logitech-hidpp"
  ];

  # --- Services ---
  services.lact.enable = lib.mkIf (hw.gpu == "amd") (lib.mkDefault true);

  # --- Hardware Diagnostic & Management Packages ---
  environment.systemPackages =
    lib.optionals (hw.gpu == "amd") (with pkgs; [
      amdgpu_top
      lact
      nvtopPackages.amd
      radeontop
      rocmPackages.rocm-smi
      rocmPackages.rocminfo
    ])
    ++ lib.optionals (hw.gpu == "intel") (with pkgs; [
      intel-gpu-tools
      nvtopPackages.intel
    ])
    ++ lib.optionals (hw.gpu == "msm") [
      pkgs.nvtopPackages.msm
    ]
    ++ lib.optional hw.battery.enable pkgs.gnome-power-manager
    ++ lib.optional hw.logitech.enable pkgs.logitech-udev-rules;
}
