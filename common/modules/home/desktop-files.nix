{
  config,
  pkgs,
  ...
}:

{
  /*
    xdg.desktopEntries = {
       "clion" = {
        name = "CLion (Nix Shell)";
        genericName = "C/C++ IDE from JetBrains";
        exec = "nix develop ${config.xdg.configHome}/nix-shells/cpp -c clion %f";
        icon = "clion";
        type = "Application";
        terminal = false;
        categories = [
          "Development"
          "IDE"
        ];
        settings = {
          StartupWMClass = "jetbrains-clion";
        };
        mimeType = [
          "text/x-c++src"
          "text/x-c++hdr"
          "text/x-csrc"
          "text/x-chdr"
        ];
      };
    };
  */

  xdg.dataFile."applications/clion.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=CLion (Nix Shell)
    GenericName=C/C++ IDE from JetBrains
    Exec=sh -c "nix develop ${config.xdg.configHome}/nix-shells/cpp -c clion %f"
    Icon=clion
    Terminal=false
    Categories=Development;IDE;
    StartupWMClass=jetbrains-clion
    MimeType=text/x-c++src;text/x-c++hdr;text/x-csrc;text/x-chdr;
  '';
}
