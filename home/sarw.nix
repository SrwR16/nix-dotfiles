{userConfig, ...} @ inputs: let
  listNixModulesRecusive = import ../lib/listNixModulesRecusive.nix inputs;

  # Create defaults from user configuration
  defaults = {
    username = userConfig.name;
    password = userConfig.name;
    full-name = userConfig.fullName;
    primary-email = userConfig.email;
    avatar-image = userConfig.avatar;
    keyMap = userConfig.system.keyMap;
    timeZone = userConfig.system.timeZone;
    defaultLocale = userConfig.system.locale.default;
    region = userConfig.system.locale.default;
    editor = "code"; # Default editor
  };
in {
  imports = listNixModulesRecusive ../modules/home-manager;

  home = {
    stateVersion = userConfig.system.stateVersion;
    username = userConfig.name;
  };

  # Make defaults available to all modules
  _module.args = {
    inherit defaults;
    gitKey = userConfig.gitKey or null;
  };
}
