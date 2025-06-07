{
  pkgs,
  defaults,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";
    base16Scheme = defaults.colorScheme;
    image = ../../../files/wallpaper/wallpaper1.jpg;
    fonts = defaults.fonts;
    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      size = 24;
    };
  };
}
