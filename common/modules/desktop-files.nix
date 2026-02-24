{
  pkgs,
  ...
}:

{

  environment.systemPackages = with pkgs; [
    (makeDesktopItem {
      name = "clion-nix-shell";
      desktopName = "CLion (Nix Shell)";
      genericName = "C/C++ IDE from JetBrains";
      exec = "sh -c \"nix develop ~/.config/nix-shells/cpp -c clion %f\"";
      icon = "clion";
      type = "Application";
      terminal = false;
      categories = [
        "Development"
        "IDE"
      ];
      startupWMClass = "jetbrains-clion";
      mimeTypes = [
        "text/x-c++src"
        "text/x-c++hdr"
        "text/x-csrc"
        "text/x-chdr"
      ];
    })
  ];
}
