{pkgs, ...}: {
  home.packages = with pkgs; [
    rnote
  ];

  programs.zsh.initContent = ''
    switch_slot() {
      CURRENT_SLOT=$(sudo qbootctl -a 2> /dev/null | grep -Eo "_(a|b)")
      case $CURRENT_SLOT in
      _a)
        NEXT_SLOT=b
        ;;
      _b)
        NEXT_SLOT=a
        ;;
      *)
        echo "Unknown slot! Something must have gone horribly wrong..."
        ;;
      esac

      echo "Current slot is \"$CURRENT_SLOT\". Switching to \"_$NEXT_SLOT\"..."
      sudo qbootctl -s $NEXT_SLOT 2> /dev/null
    }
  '';
}
