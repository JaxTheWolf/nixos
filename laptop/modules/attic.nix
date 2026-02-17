{ ... }: {
  nix.settings = {
    substituters = [
      "https://attic.awroo.fun/my-config"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "my-config:zMLOKdd9wxVtJDK2jgI2fW6Uehtdc4WLyU0bOjNpyxM="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trusted-users = [ "root" "@wheel" ];
  };
}