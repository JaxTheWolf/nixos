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
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
