{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "monokai_soda";

      editor = {
        bufferline = "multiple";
        cursorline = true;
        line-number = "relative";
        lsp.display-inlay-hints = true;

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

      keys = {
        normal = {
          "R" = ":reload-all";
          "L" = "goto_next_buffer";
          "H" = "goto_previous_buffer";
          "home" = "goto_first_nonwhitespace";
          "C-s" = ":w";

          space = {
            "i" = ":toggle lsp.display-inlay-hints";
          };
        };

        insert = {
          "home" = "goto_first_nonwhitespace";
          "C-s" = [":w" "normal_mode"];
        };

        select = {
          "home" = "goto_first_nonwhitespace";
          "C-s" = ":w";
        };
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

    extraPackages = with pkgs; [
      alejandra
      nil
      wl-clipboard
    ];
  };
}
