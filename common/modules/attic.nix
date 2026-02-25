{
  ...
}:
{
  nix.settings = {
    substituters = [
      "https://attic.awroo.fun/my-config"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "my-config:51aC90S8+3+gS/UzwdnL7a7lu1NnY896SZp5njMwFDk="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
