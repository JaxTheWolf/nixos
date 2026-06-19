{
  lib,
  osConfig,
  ...
}: {
  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        rate = "500ms";
        battery = true;
        network_use_bytes = true;
        enable_cache_memory = true;
        is_list_ignored = true;
        list = ["virbr0.*"];
      };

      styles = {
        theme = "gruvbox";
      };

      row = [
        # --- TOP ROW ---
        {
          ratio = 35;
          child = [{type = "cpu";}];
        }

        # --- BOTTOM ROW ---
        {
          ratio = 65;
          child = [
            # --- LEFT COLUMN ---
            {
              ratio = 55;
              child =
                [
                  {type = "disk";}
                  {type = "temp";}
                  {type = "net";}
                ]
                ++ lib.optionals (osConfig.networking.hostName == "dalaptop" && osConfig.networking.hostName == "pipa") [
                  {type = "batt";}
                ];
            }

            # --- RIGHT COLUMN ---
            {
              ratio = 45;
              child = [
                {type = "mem";}
                {type = "proc";}
              ];
            }
          ];
        }
      ];
    };
  };
}
