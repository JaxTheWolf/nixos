{...}: {
  programs.zellij = {
    enable = true;

    settings = {
      pane_frames = false;
      default_shell = "zsh";
      show_startup_tips = false;
      serialize_pane_viewport = false;
    };

    layouts = {
      helix-term = ''
        default_mode "locked"

        layout {
            pane size="75%" command="hx" name="Helix Editor" {
                focus true
            }

            pane size="25%" name="Git & Terminal" borderless=false

            pane size=1 borderless=true {
                plugin location="zellij:status-bar"
            }
        }
      '';
    };
  };
}
