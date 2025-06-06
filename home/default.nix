{userConfig ? null, defaults ? null, ...} @ inputs: let
  listNixModulesRecusive = import ../lib/listNixModulesRecusive.nix inputs;

  # Create defaults from user configuration if provided, otherwise use system defaults
  homeDefaults = if userConfig != null then {
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
  } else defaults;
in {
  imports = listNixModulesRecusive ../modules/home-manager;

  home = {
    stateVersion = if userConfig != null then userConfig.system.stateVersion else "24.05";
    username = if userConfig != null then userConfig.name else defaults.username;
  };

  # Make defaults and gitKey available to all modules
  _module.args = {
    defaults = homeDefaults;
    gitKey = if userConfig != null then (userConfig.gitKey or null) else null;
  };
}
