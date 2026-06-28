{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gnome-power-manager
      nvtopPackages.msm
    ];
  };
}
