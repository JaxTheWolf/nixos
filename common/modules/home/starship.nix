{
  lib,
  ...
}:

{
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$hostname"
        "\${custom.distrobox}"
        "$nix_shell"
        "$python"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "\${custom.android}"
        "[](fg:#000000)"
        "[░▒▓](#FFFFFF)"
        "[ 🐺 ](bg:#FFFFFF fg:#1E91D6)"
        "[](bg:#0072BB fg:#FFFFFF)"
        "$directory"
        "[](fg:#0072BB bg:#E18335)"
        "$git_branch"
        "$git_status"
        "[](fg:#E18335 bg:#061A40)"
        "$time"
        "[ ](fg:#061A40)"
        "\n$character"
      ];

      hostname = {
        ssh_only = true;
        format = "[](fg:#1E91D6)[$hostname](bg:#1E91D6 fg:#FFFFFF)[](fg:#1E91D6) ";
      };

      custom.distrobox = {
        when = "printenv CONTAINER_ID";
        command = "echo $CONTAINER_ID";
        format = "[](fg:#FF5F00)[󰏖 $output ](bg:#FF5F00 fg:#FFFFFF)[](fg:#FF5F00) ";
      };

      nix_shell = {
        format = "[](fg:#7EBAE4)[ $state ](bg:#7EBAE4 fg:#061A40)[](fg:#7EBAE4) ";
      };

      custom.android = {
        when = "test -n \"$IN_ANDROID_ENV\"";
        format = "[](fg:#3DDC84)[󰀲 Android ](bg:#3DDC84 fg:#061A40)[](fg:#3DDC84) ";
      };

      directory = {
        style = "fg:#e3e5e5 bg:#0072BB";
        format = "[ $path ]($style)";
        truncation_length = 3;
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = "󰇚 ";
          "Music" = "󰝚 ";
          "Pictures" = "󰙏 ";
        };
      };

      git_branch = {
        symbol = "󰊢";
        style = "bg:#E18335";
        format = "[[ $symbol $branch ](fg:#0072BB bg:#E18335)]($style)";
      };

      git_status = {
        style = "bg:#E18335";
        format = "[[($all_status$ahead_behind )](fg:#0072BB bg:#E18335)]($style)";
      };

      python = {
        symbol = "󰌠";
        format = "[](fg:#4B8BBE)[$symbol $version](bg:#4B8BBE fg:#FFFFFF)[](fg:#4B8BBE) ";
      };

      nodejs = {
        symbol = "󰎙";
        format = "[](fg:#68A063)[$symbol $version](bg:#68A063 fg:#FFFFFF)[](fg:#68A063) ";
      };

      rust = {
        symbol = "󱘗";
        format = "[](fg:#CE412B)[$symbol $version](bg:#CE412B fg:#FFFFFF)[](fg:#CE412B) ";
      };

      golang = {
        symbol = "󰟓";
        format = "[](fg:#00ADD8)[$symbol $version](bg:#00ADD8 fg:#FFFFFF)[](fg:#00ADD8) ";
      };

      php = {
        symbol = "󰌟";
        format = "[](fg:#8892BF)[$symbol $version](bg:#8892BF fg:#FFFFFF)[](fg:#8892BF) ";
      };

      time = {
        disabled = false;
        style = "bg:#061A40";
        format = "[[ 󰥔 $time ](fg:#a0a9cb bg:#061A40)]($style)";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };
}
