{
  description = "Latest CLion from JetBrains";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
      };
    };
  in {
    packages.${system}.default = pkgs.jetbrains.clion.overrideAttrs (oldAttrs: rec {
      version = "2026.1";
      src = pkgs.fetchurl {
        url = "https://download-cdn.jetbrains.com/cpp/CLion-${version}.tar.gz";
        hash = "sha256-r5flY2u6aCkI8q7ZcGWYLLxxcWWp3gtTkdBdKoacIB0=";
      };
      buildInputs = oldAttrs.buildInputs ++ [pkgs.openssl_1_1];
    });
  };
}
