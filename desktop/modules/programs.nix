{
  config,
  pkgs,
  lib,
  ...
}: {
  programs = {
    ccache = {
      enable = true;
      cacheDir = "/media/data/.ccache";
    };
  };
}
