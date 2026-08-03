{pkgs, ...}: {
  programs = {
    btop = {
      settings.cpu_sensor = "zenmonitor/Tdie";
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

  xdg.configFile = {
    "MangoHud/MangoHud.conf".text = ''
      toggle_fps_limit=F1
      legacy_layout=false
      pci_dev=0:2d:00.0
      cpu_stats
      graphs=cpu_load
      cpu_temp
      cpu_power
      cpu_mhz
      cpu_load_change
      cpu_color=DE0835
      cpu_text=R7 5800X
      gpu_stats
      graphs=gpu_load
      gpu_temp
      gpu_core_clock
      gpu_mem_clock
      gpu_power
      gpu_text=GPU
      gpu_name
      io_read
      io_write
      io_color=D8D8D8
      swap
      vram
      vram_color=DE0835
      ram
      ram_color=DE0835
      fps
      engine_version
      engine_color=950524
      gpu_color=DE0835
      vulkan_driver
      vkbasalt
      gpu_fan
      wine_color=950524
      frame_timing=1
      frametime_color=DE0835
      throttling_status
      media_player_color=950524
      table_columns=3
      background_alpha=0.4
      font_size=19
      background_color=020202
      position=top-left
      text_color=D8D8D8
      round_corners=4
      toggle_hud=Shift_R+F12
      toggle_logging=Shift_L+F2
      upload_log=F5
      output_folder=/home/jax
      media_player_name=spotify
    '';

    "autostart/01-zenmonitor.desktop".source = "${pkgs.zenmonitor}/share/applications/zenmonitor.desktop";

    "autostart/01-openrgb.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenRGB
      Exec=${pkgs.openrgb-with-all-plugins}/bin/openrgb --startminimized --profile "yee"
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';

    "autostart/03-steam.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Steam
      Exec=steam -silent
      Icon=steam
      Terminal=false
      X-GNOME-Autostart-enabled=true
    '';
  };
}
