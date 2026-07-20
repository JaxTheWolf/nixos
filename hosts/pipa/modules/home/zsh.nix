_: {
  programs.zsh = {
    initContent = ''
      switch_slot() {
        CURRENT_SLOT=$(sudo qbootctl -a 2> /dev/null | grep -Eo "_(a|b)")
        echo "Current slot is $CURRENT_SLOT."
        case $CURRENT_SLOT in
          _a)
            NEXT_SLOT=b
            ;;
          _b)
            NEXT_SLOT=a
            ;;
          *)
            echo "Invalid slot." >&2
            return 1
            ;;
        esac

        sudo qbootctl -s $NEXT_SLOT > /dev/null 2>&1
        echo "Switched slot to _$NEXT_SLOT."
        if [[ "$1" = "r" ]]; then
          echo "Rebooting..."
          sleep 3
          sudo reboot
        fi
        return 0
      }
    '';
  };
}
