{
  pkgs,
  defaults,
  ...
}: {
  # users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users.root.initialPassword = defaults.password;

  users.users.${defaults.username} = {
    isNormalUser = true;

    description = defaults.full-name;
    initialPassword = defaults.password;

    shell = pkgs.fish;
    extraGroups = [
      "adbusers"
      "audio"
      "docker"
      "input"
      "kvm"
      "libvirtd"
      "lxd"
      "networkmanager"
      "qemu-libvirtd"
      "users"
      "video"
      "wheel"
      "ydotool"
    ];

    openssh.authorizedKeys.keyFiles = [
      (pkgs.fetchurl defaults.pubKeys)
    ];
  };
}
