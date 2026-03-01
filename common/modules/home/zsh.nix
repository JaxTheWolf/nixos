{
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "sudo"
        "vscode"
        "z"
        "colorize"
      ];
    };

    shellAliases = {
      adbauto = "adbauto_";
      adbpair = "adbpair_";
    };

    sessionVariables = {
      LIBVIRT_DEFAULT_URI = "qemu:///system";
      ZSH_AUTOSUGGEST_STRATEGY = [
        "history"
        "completion"
      ];
    };

    initContent = ''
      # Completion Styling
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
      zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
      zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
      zstyle ':completion:*' matcher-list "" 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

      # Path Management
      export PATH="$HOME/.local/bin:/usr/local/LinkServer/:$PATH"

      # Dart Completion
      [[ -f /home/jax/.dart-cli-completion/zsh-config.zsh ]] && . /home/jax/.dart-cli-completion/zsh-config.zsh || true

      adbauto_() {
        local PORT=$(avahi-browse -rt _adb-tls-connect._tcp -p | grep '^=' | cut -d';' -f8,9 | head -n 1 | sed 's/;/ /' | awk '{print $2}')
        local IP=$(avahi-browse -rt _adb-tls-connect._tcp -p | grep '^=' | cut -d';' -f8,9 | head -n 1 | sed 's/;/ /' | awk '{print $1}')
        if [ -z "$PORT" ]; then
          echo "No Wireless ADB service found. Is Wireless Debugging on?"
        else
          echo "Connecting to $IP:$PORT..."
          adb connect $IP:$PORT
        fi
      }

      adbpair_() {
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

      if ! command -v starship >/dev/null 2>&1; then
        if [[ -f "/home/jax/.cargo/bin/starship" ]]; then
          eval "$(/home/jax/.cargo/bin/starship init zsh)"
        fi
      fi

      # Your specific Android environment override
      if [[ -n "$IN_ANDROID_ENV" ]]; then
          eval "$(starship init zsh)"
      fi
    '';
  };

  programs.starship.enable = true;
}
