_: {
  nix.settings = {
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
  };
}
