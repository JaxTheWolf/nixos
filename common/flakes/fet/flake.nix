{
  description = "FET - Free Timetabling Software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "fet";
          version = "7.7.6";

          src = pkgs.fetchurl {
            url = "https://lalescu.ro/liviu/fet/download/fet-${version}.tar.xz";
            sha256 = "06vvxxl5kza3a2v0fkw6bylavpickk8a5ybgabbhylmi59c1q1ns";
          };

          enableParallelBuilding = true;

          nativeBuildInputs = [
            pkgs.qt6.qmake
            pkgs.qt6.wrapQtAppsHook
            pkgs.copyDesktopItems
          ];

          buildInputs = [
            pkgs.qt6.qtbase
          ];

          configurePhase = ''
            qmake fet.pro
          '';

          desktopItems = [
            (pkgs.makeDesktopItem {
              name = "fet";
              exec = "fet";
              icon = "fet";
              comment = "Free Timetabling Software";
              desktopName = "FET";
              categories = [
                "Education"
                "Qt"
              ];
            })
          ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp fet $out/bin/

            mkdir -p $out/share/icons/hicolor/128x128/apps
            cp icons/fet.png $out/share/icons/hicolor/128x128/apps/fet.png

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Free software for automatically scheduling timetables";
            homepage = "https://lalescu.ro/liviu/fet/";
            license = licenses.agpl3Plus;
            platforms = platforms.linux;
            mainProgram = "fet";
          };
        };
      }
    );
}
