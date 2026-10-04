{
  inputs,
  self ? inputs.self,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.17"
      ];
    };

    overlays = [
      self.overlays.default
    ];
  };

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];

    auto-optimise-store = true;
    extra-platforms = ["aarch64-linux" "i686-linux"];
    warn-dirty = false;

    substituters = [
      "https://cache.nixos.org"
      "https://attic.awruff.fun/my-config"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "my-config:hK+qaX2TdSrf/sp8LjKq9VF9XU0qGksoQCdgVXfgWoQ="
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];

    connect-timeout = 3;
    fallback = true;
  };
}
