{
  lib,
  config,
  ...
}: {
  security = {
    rtkit.enable = true;

    sudo.extraConfig = ''
      Defaults insults
    '';

    polkit.extraConfig = lib.mkIf config.myConfig.virtualisation.libvirtd.enable ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.isInGroup("qemu-libvirtd")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
