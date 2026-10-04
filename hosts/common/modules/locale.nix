{lib, ...}: {
  time.timeZone = "Europe/Prague";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_MEASUREMENT"
      "LC_MONETARY"
      "LC_NAME"
      "LC_NUMERIC"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ] (_: "cs_CZ.UTF-8");
  };

  services.xserver.xkb = {
    layout = "cz";
    variant = "";
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
}
