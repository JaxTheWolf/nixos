{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = ["history" "completion" "match_prev_cmd"];
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      extended = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
      save = 10000;
      size = 10000;
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master";
          sha256 = "sha256-YhTSu0P7mFlVx1zBvbT0jNstkamcZHhPYJHKMAHgyuM=";
        };
      }
    ];

    shellAliases = {
      cat = "bat";
      hxg = "SESSION_NAME=\$(basename \$PWD); zellij delete-session \$SESSION_NAME 2>/dev/null; zellij --new-session-with-layout helix-term -s \$SESSION_NAME";
    };

    initContent = ''
      zstyle ':completion:*' completer _complete _match _approximate
      zstyle ':completion:*:approximate:*' max-errors 1 numeric

      zstyle ':completion:*' menu select

      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
      zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
      zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
      zstyle ':completion:*' matcher-list "" 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

      # Dart Completion (Safely quoted to prevent bash from misinterpreting the nix string)
      [[ -f "${config.home.homeDirectory}/.dart-cli-completion/zsh-config.zsh" ]] && . "${config.home.homeDirectory}/.dart-cli-completion/zsh-config.zsh" || true

      adbauto() {
        local PORT=$(avahi-browse -rt _adb-tls-connect._tcp -p | grep '^=' | cut -d';' -f8,9 | head -n 1 | sed 's/;/ /' | awk '{print $2}')
        local IP=$(avahi-browse -rt _adb-tls-connect._tcp -p | grep '^=' | cut -d';' -f8,9 | head -n 1 | sed 's/;/ /' | awk '{print $1}')
        if [ -z "$PORT" ]; then
          echo "No Wireless ADB service found. Is Wireless Debugging on?"
        else
          echo "Connecting to $IP:$PORT..."
          adb connect $IP:$PORT
        fi
      }

      adbpair() {
        echo "Looking for Android pairing service..."
        local SERVICE=$(avahi-browse -rt _adb-tls-pairing._tcp -p | grep '^=' | head -n 1)
        if [ -z "$SERVICE" ]; then
          echo "Error: Pairing service not found. Make sure 'Pair device with pairing code' is open on your phone."
          return 1
        fi
        local IP=$(echo "$SERVICE" | cut -d';' -f8)
        local PORT=$(echo "$SERVICE" | cut -d';' -f9)
        echo "Found device at $IP:$PORT"
        adb pair "$IP:$PORT"
      }

      nsp() {
        IN_NIX_SHELL="impure" nix shell $(echo "$@" | sed 's/\([^ ]*\)/nixpkgs#\1/g')
      }

      # Dank `sudo` OMZ plugin replacement
      prepend-sudo() {
        if [[ $BUFFER != su(do|)\ * ]]; then
          BUFFER="sudo $BUFFER"
          (( CURSOR+=5 ))
        else
          BUFFER=''${BUFFER#su }
          BUFFER=''${BUFFER#sudo }
        fi
      }

      zle -N prepend-sudo
      bindkey "\e\e" prepend-sudo

      # --- NixOS Default Keybindings (terminfo + fallback) ---
      typeset -g -A key

      key[Home]="''${terminfo[khome]}"
      key[End]="''${terminfo[kend]}"
      key[Insert]="''${terminfo[kich1]}"
      key[Delete]="''${terminfo[kdch1]}"
      key[Up]="''${terminfo[kcuu1]}"
      key[Down]="''${terminfo[kcud1]}"
      key[Left]="''${terminfo[kcub1]}"
      key[Right]="''${terminfo[kcuf1]}"
      key[PageUp]="''${terminfo[kpp]}"
      key[PageDown]="''${terminfo[knp]}"
      key[Shift-Tab]="''${terminfo[kcbt]}"

      [[ -n "''${key[Home]}"     ]] && bindkey "''${key[Home]}"     beginning-of-line
      [[ -n "''${key[End]}"      ]] && bindkey "''${key[End]}"      end-of-line
      [[ -n "''${key[Insert]}"   ]] && bindkey "''${key[Insert]}"   overwrite-mode
      [[ -n "''${key[Delete]}"   ]] && bindkey "''${key[Delete]}"   delete-char
      [[ -n "''${key[Up]}"       ]] && bindkey "''${key[Up]}"       up-line-or-history
      [[ -n "''${key[Down]}"     ]] && bindkey "''${key[Down]}"     down-line-or-history
      [[ -n "''${key[Left]}"     ]] && bindkey "''${key[Left]}"     backward-char
      [[ -n "''${key[Right]}"    ]] && bindkey "''${key[Right]}"    forward-char
      [[ -n "''${key[PageUp]}"   ]] && bindkey "''${key[PageUp]}"   beginning-of-buffer-or-history
      [[ -n "''${key[PageDown]}" ]] && bindkey "''${key[PageDown]}" end-of-buffer-or-history
      [[ -n "''${key[Shift-Tab]}" ]] && bindkey "''${key[Shift-Tab]}" reverse-menu-complete

      # Fallback escape sequences across SSH (in case terminfo is missing or incomplete)
      bindkey '^[[3~'  delete-char
      bindkey '^[3;5~' delete-char
      bindkey '^[[H'   beginning-of-line
      bindkey '^[[F'   end-of-line
      bindkey '^[[1~'  beginning-of-line
      bindkey '^[[4~'  end-of-line
      bindkey '^[OH'   beginning-of-line
      bindkey '^[OF'   end-of-line
      bindkey '^[[2~'  overwrite-mode
      bindkey '^[[5~'  beginning-of-buffer-or-history
      bindkey '^[[6~'  end-of-buffer-or-history

      # Word navigation & deletion
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '^H' backward-kill-word

      # Enable application keypad mode when ZLE is active for reliable terminfo codes
      if (( ''${+terminfo[smkx]} )) && (( ''${+terminfo[rmkx]} )); then
        zle-line-init() {
          printf '%s' "''${terminfo[smkx]}"
        }
        zle-line-finish() {
          printf '%s' "''${terminfo[rmkx]}"
        }
        zle -N zle-line-init
        zle -N zle-line-finish
      fi
    '';
  };
}
