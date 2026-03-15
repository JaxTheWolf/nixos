{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    ccache = {
      enable = true;
      cacheDir = "/media/data/.ccache";
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-backgroundremoval
        obs-gstreamer
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    };
  };
}
