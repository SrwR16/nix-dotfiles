{
  defaults,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    kooha
    libnotify
    polkit_gnome
    raise-or-open-url
  ];

  # https://github.com/emersion/mako/blob/master/doc/mako.5.scd
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      markup = true;
      icons = true;
      layer = "overlay";
      anchor = "top-right";
      border-size = 0;
      border-radius = 10;
      padding = 10;
      width = 330;
      height = 200;
      default-timeout = 5000;
      max-icon-size = 32;
      text-color = lib.mkForce "#${defaults.colorScheme.palette.base00}";
      background-color = lib.mkForce "#${defaults.colorScheme.palette.base0D}";
    };
  };
}
