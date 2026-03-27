{...}: {
  nix.settings = {
    substituters = [
      "https://attic.awroo.fun/my-config"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "my-config:hK+qaX2TdSrf/sp8LjKq9VF9XU0qGksoQCdgVXfgWoQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
