{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      gnome-power-manager
      nvtopPackages.msm
    ];
  };
}
