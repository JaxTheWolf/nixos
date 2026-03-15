{
  config,
  pkgs,
  ...
}:
{
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

  xdg.dataFile."applications/cisco-packet-tracer-9.desktop".text = ''
    [Desktop Entry]
    StartupWMClass=PacketTracer
    Name=Cisco Packet Tracer 9.0.0
    Type=Application
    Categories=Education;
    Exec=env QT_STYLE_OVERRIDE=adwaita packettracer9 %f
    Icon=cisco-packet-tracer-9
    Terminal=false
    StartupNotify=true
    MimeType=application/x-pkt;application/x-pka;application/x-pkz;application/x-pks;application/x-pksz;
  '';
}
