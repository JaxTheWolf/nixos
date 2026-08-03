{pkgs, ...}: {
  programs = {
    mangohud = {
      settings = {
        toggle_fps_limit = "F1";
        legacy_layout = false;
        pci_dev = "0:2d:00.0";
        cpu_stats = true;
        graphs = "cpu_load,gpu_load";
        cpu_temp = true;
        cpu_power = true;
        cpu_mhz = true;
        cpu_load_change = true;
        cpu_color = "DE0835";
        cpu_text = "R7 5800X";
        gpu_stats = true;
        gpu_temp = true;
        gpu_core_clock = true;
        gpu_mem_clock = true;
        gpu_power = true;
        gpu_text = "GPU";
        gpu_name = true;
        io_read = true;
        io_write = true;
        io_color = "D8D8D8";
        swap = true;
        vram = true;
        vram_color = "DE0835";
        ram = true;
        ram_color = "DE0835";
        fps = true;
        engine_version = true;
        engine_color = "950524";
        gpu_color = "DE0835";
        vulkan_driver = true;
        vkbasalt = true;
        gpu_fan = true;
        wine_color = "950524";
        frame_timing = 1;
        frametime_color = "DE0835";
        throttling_status = true;
        media_player_color = "950524";
        table_columns = 3;
        background_alpha = "0.4";
        font_size = 19;
        background_color = "020202";
        position = "top-left";
        text_color = "D8D8D8";
        round_corners = 4;
        toggle_hud = "Shift_R+F12";
        toggle_logging = "Shift_L+F2";
        upload_log = "F5";
        output_folder = "/home/jax";
      };
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
