{
  description = "Solaar built from GitHub master branch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # This input automatically tracks the latest commit on master
    solaar-src = {
      url = "github:pwr-Solaar/Solaar/master";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      solaar-src,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pythonPackages = pkgs.python3Packages;
      in
      {
        packages.default = pythonPackages.buildPythonApplication rec {
          pname = "solaar";
          version = "master-${solaar-src.shortRev or "dirty"}";

          src = solaar-src;

          # --- FIX STARTS HERE ---
          # 1. Enable pyproject format
          pyproject = true;

          # 2. Add build tools (setuptools/wheel) to nativeBuildInputs
          nativeBuildInputs =
            with pkgs;
            [
              gobject-introspection
              wrapGAppsHook3
              pkg-config
            ]
            ++ (with pythonPackages; [
              setuptools
              wheel
            ]);
          # --- FIX ENDS HERE ---

          propagatedBuildInputs = with pythonPackages; [
            pyudev
            psutil
            xlib
            pyyaml
            evdev
            dbus-python
            pygobject3
            typing-extensions

            pkgs.gtk3
            pkgs.libnotify
            pkgs.libayatana-appindicator
          ];

          postInstall = ''
            install -Dm644 rules.d/42-logitech-unify-permissions.rules \
              $out/lib/udev/rules.d/42-logitech-unify-permissions.rules
          '';

          doCheck = false;
        };
      }
    );
}
