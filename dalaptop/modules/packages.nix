{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnome-power-manager
    intel-gpu-tools
    nvtopPackages.intel
  ];
}
