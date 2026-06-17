{pkgs, ...}: {
  programs.helix = {
    enable = true;

    settings = {
      theme = "transparent_mocha";

      editor = {
        bufferline = "multiple";
        cursorline = true;
        line-number = "relative";

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides = {
          character = "│";
          enable = true;
        };
      };

      keys.normal = {
        "R" = ":reload";
        "L" = "goto_next_buffer";
        "H" = "goto_previous_buffer";
        "home" = "goto_first_nonwhitespace";
        "C-s" = ":w";
      };

      keys.insert = {
        "home" = "goto_first_nonwhitespace";
        "C-s" = [":w" "normal_mode"];
      };

      keys.select = {
        "home" = "goto_first_nonwhitespace";
        "C-s" = ":w";
      };
    };

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
            args = ["-"];
          };
        }
      ];
    };

    themes = {
      transparent_mocha = {
        inherits = "catppuccin_mocha";

        operator = "sky";
        punctuation = "text";
        "punctuation.bracket" = "text";
        "punctuation.delimiter" = "text";

        comment = {
          fg = "lavender";
          modifiers = ["italic"];
        };

        "ui.linenr" = "subtext0";
        "ui.linenr.selected" = "peach";
        "ui.background" = {bg = "none";};
        "ui.gutter" = {bg = "none";};
        "ui.help" = {bg = "none";};
        "ui.menu" = {bg = "none";};
        "ui.popup" = {bg = "none";};
        "ui.virtual.whitespace" = {bg = "none";};
        "ui.window" = {bg = "none";};
      };
    };

    extraPackages = with pkgs; [
      alejandra
      nil
      wl-clipboard
    ];
  };
}
