{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zsh = {
    enableCompletion = true;
    autosuggestion.enable = true;
    autosuggestion.strategy = ["history" "completion" "match_prev_cmd"];
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master";
          sha256 = "sha256-yvPQyuK4Dw+LkwxrkWTRcw4PIf/79fW61jWbEg8Pe9Y=";
        };
      }
    ];

    shellAliases = {
      cat = "bat";
    };

    sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
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

      # Path Management
      export PATH="${config.home.homeDirectory}/.local/bin:/usr/local/LinkServer/:$PATH"

      export FLAKE="${config.xdg.configHome}/nixos"

      # Dart Completion (Safely quoted to prevent bash from misinterpreting the nix string)
      [[ -f "${config.home.homeDirectory}/.dart-cli-completion/zsh-config.zsh" ]] && . "${config.home.homeDirectory}/.dart-cli-completion/zsh-config.zsh" || true

      if command -v nix-your-shell > /dev/null; then
        nix-your-shell zsh | source /dev/stdin
      fi

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
          CURSOR+=5
        fi
      }

      zle -N prepend-sudo
      bindkey "\e\e" prepend-sudo
    '';
  };
}
