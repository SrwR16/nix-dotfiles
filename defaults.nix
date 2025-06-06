{
  pkgs,
  nix-colors,
  ...
}: let
  # Load user configuration
  userConfig = import ./userConfig.nix;
  primaryUser = userConfig.users.${userConfig.primaryUser};
  username = userConfig.primaryUser;
in {
  inherit username;
  password = username;
  full-name = primaryUser.fullName;
  location = "Vilassar de Mar"; # Keep original default
  primary-email = primaryUser.email;

  # Use primary user's system configuration
  keyMap = primaryUser.system.keyMap;
  timeZone = primaryUser.system.timeZone;
  defaultLocale = primaryUser.system.locale.default;
  region = primaryUser.system.locale.default;

  avatar-image = if (primaryUser ? avatar) then primaryUser.avatar else null;

  editor = "re.sonny.Commit";

  pubKeys = {
    url = "https://github.com/SrwR16.keys";
    sha256 = "sha256-2/Rt+0yWTv//9Sg5Ibr2/YE2JH+AtLXP95kUJpBhTS8=";
  };

  # fc-list : family
  fonts = {
    sizes.applications = 11;

    sansSerif = {
      name = "Inter";
      package = pkgs.inter;
    };

    serif = {
      name = "Roboto Slab";
      package = pkgs.roboto;
    };

    emoji = {
      name = "Twitter Color Emoji";
      package = pkgs.twitter-color-emoji;
    };

    monospace = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
  };

  # https://catppuccin.com/palette
  # https://nico-i.github.io/scheme-viewer/base16/
  # https://github.com/tinted-theming/base16-schemes/
  # open file:///etc/stylix/palette.html
  colorScheme =
    pkgs.lib.attrsets.recursiveUpdate
    nix-colors.colorSchemes.catppuccin-mocha
    {
      palette.base0D = "fad000";
    };

  display = {
    width = 1920 * 2;
    height = 1080 * 2;
    windowSize = [1240 900];
    sidebarWidth = 200;
  };
}
