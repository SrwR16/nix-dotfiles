{
  pkgs,
  defaults,
  ...
}: {
  services = {
    udev.packages = with pkgs; [
      via
    ];
    pulseaudio.enable = false;
    fstrim.enable = true;
    # btrfs.autoScrub.enable = true; # Disabled: no btrfs filesystems

    systembus-notify = {
      enable = true;
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        systembus-notify.enable = true;
      };
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    sunshine = {
      enable = false;
      autoStart = true;
      capSysAdmin = true;
    };

    plex = {
      enable = true;
      group = "wheel";
      user = defaults.username;
    };

    atd = {
      enable = true;
      allowEveryone = true;
    };

    ollama = {
      enable = true;
      acceleration = "cuda";
      host = "[::]";
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_CONTEXT_LENGTH = "8192";
      };
    };
  };
}
