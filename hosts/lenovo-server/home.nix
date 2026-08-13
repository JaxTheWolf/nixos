{pkgs, ...}: {
  home.packages = with pkgs; [
    restic
  ];

  programs.zsh.shellAliases = {
    update = "sudo dnf update";
  };
}
