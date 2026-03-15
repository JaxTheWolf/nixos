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
          version = "7.8.0";

          src = pkgs.fetchurl {
            url = "https://lalescu.ro/liviu/fet/download/fet-${version}.tar.xz";
            sha256 = "01hr3digrg2qs5wh10qzpgwi4clqmzd46d099r0yrx3278qvz9wj";
          };

          enableParallelBuilding = true;

          nativeBuildInputs = with pkgs; [
            copyDesktopItems
            qt6.qmake
            qt6.wrapQtAppsHook
          ];

          buildInputs = with pkgs; [
            qt6.qtbase
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
