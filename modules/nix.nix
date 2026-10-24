{
  inputs,
  self ? inputs.self,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ventoy-gtk3-1.1.18"
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
      "https://attic.awruff.fun/my-config"
      "https://cache.xinux.uz"
    ];

    trusted-public-keys = [
      "my-config:hK+qaX2TdSrf/sp8LjKq9VF9XU0qGksoQCdgVXfgWoQ="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];

    connect-timeout = 3;
    fallback = true;
  };
}
