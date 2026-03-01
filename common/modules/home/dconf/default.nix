{
  ...
}:

{
  imports = [
    ./apps.nix
    ./extensions.nix
    ./gnome.nix
  ];

  dconf.settings = {
    "system/locale" = {
      region = "cs_CZ.UTF-8";
    };
  };
}
