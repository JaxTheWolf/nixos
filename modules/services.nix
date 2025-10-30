{
  config,
  pkgs,
  lib,
  ...
}:

{
  services = {
    lact.enable = true;
    printing.enable = true;
    flatpak = {
      enable = true;
      remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];
      packages = [
        {
          appId = "com.mattjakeman.ExtensionManager";
          origin = "flathub";
        }
        {
          appId = "com.prusa3d.PrusaSlicer";
          origin = "flathub";
        }
        {
          appId = "com.github.tchx84.Flatseal";
          origin = "flathub";
        }
        {
          appId = "org.gtk.Gtk3theme.Adwaita-dark";
          origin = "flathub";
        }
        # {
        #   appId = "org.freedesktop.Platform.ffmpeg-full";
        #   origin = "flathub";
        # }
        {
          appId = "org.gtk.Gtk3theme.Flat-Remix-GTK-Red-Darkest";
          origin = "flathub";
        }
        {
          appId = "com.github.iwalton3.jellyfin-media-player";
          origin = "flathub";
        }
        # {
        #   appId = "com.github.tchx84.Flatseal";
        #   origin = "flathub";
        # }
        # {
        #   appId = "com.github.tchx84.Flatseal";
        #   origin = "flathub";
        # }
        # {
        #   appId = "com.github.tchx84.Flatseal";
        #   origin = "flathub";
        # }
      ];
    };
    sshd.enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
      xkb = {
        layout = "cz";
        variant = "";
      };
    };
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    hardware.openrgb.motherboard = "amd";
    hardware.openrgb.enable = true;
  };
}
