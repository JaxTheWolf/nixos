{pkgs}: {
  enable = true;
  polarity = "dark";
  base16Scheme = "${pkgs.base16-schemes}/share/themes/primer-dark.yaml";

  image = pkgs.fetchurl {
    url = "https://d.furaffinity.net/art/-lofi/1580026261/1579917351.-lofi_1-14-20b.jpg";
    hash = "sha256-yf6ifIWKwHdG/5VelXpwPhLPD2XxFVaFZVGD/V+u118=";
  };

  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  fonts = {
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      applications = 11;
      terminal = 12;
      desktop = 11;
      popups = 10;
    };
  };
}
