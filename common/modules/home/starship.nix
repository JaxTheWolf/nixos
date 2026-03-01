{
  lib,
  ...
}:

{
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "\${custom.ssh_status}"
        "\${custom.distrobox}"
        "\${nix_shell}"
        "$python"
        "[░▒▓](#FFFFFF)"
        "[ 🐺 ](bg:#FFFFFF fg:#1E91D6)"
        "[](bg:#0072BB fg:#FFFFFF)"
        "$directory"
        "[](fg:#0072BB bg:#E18335)"
        "$git_branch"
        "$git_status"
        "[](fg:#E18335 bg:#061A40)"
        "\${custom.android}"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#061A40 bg:#1D2F51)"
        "$time"
        "[ ](fg:#1D2F51)"
        "\n$character"
      ];

      directory = {
        style = "fg:#e3e5e5 bg:#0072BB";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#E18335";
        format = "[[ $symbol $branch ](fg:#0072BB bg:#E18335)]($style)";
      };

      git_status = {
        style = "bg:#E18335";
        format = "[[($all_status$ahead_behind )](fg:#0072BB bg:#E18335)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#061A40";
        format = "[[ $symbol ($version) ](fg:#0072BB bg:#061A40)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#061A40";
        format = "[[ $symbol ($version) ](fg:#0072BB bg:#061A40)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:#061A40";
        format = "[[ $symbol ($version) ](fg:#0072BB bg:#061A40)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#061A40";
        format = "[[ $symbol ($version) ](fg:#0072BB bg:#061A40)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1D2F51";
        format = "[[  $time ](fg:#a0a9cb bg:#1D2F51)]($style)";
      };

      nix_shell = {
        disabled = false;
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        unknown_msg = "[unknown shell](bold yellow)";
        format = "via [☃️ $state( \($name\))](bold blue) ";
      };

      custom.android = {
        description = "Show label when inside Android FHS env";
        when = "test -n \"$IN_ANDROID_ENV\"";
        symbol = "🤖 ";
        style = "fg:green bg:#061A40";
        format = "[ $symbol Android ]($style)";
      };

      custom.distrobox = {
        description = "Indicate when inside a Distrobox container";
        when = "printenv CONTAINER_ID";
        command = "printenv CONTAINER_ID";
        format = "[$symbol$output]($style) ";
        symbol = "📦 ";
        style = "bold purple";
      };
    };
  };
}
