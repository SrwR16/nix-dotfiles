{

  # Primary user configuration
  primaryUser = "sarw";

  # System configuration
  system = {
    hostname = "X"; # Change this to your hostname (used for nixos-rebuild switch --flake .#HOSTNAME)
  };

  users = {
    sarw = { # Change this to your username (used for home-manager switch --flake .#USER@HOSTNAME)
      avatar = ./files/avatar/face.png; # Path to your avatar image
      email = "sarrwar16@gmail.com";
      fullName = "SARWAR";
      gitKey = "0x2226229F5F5AB870"; # Your GPG key ID
      name = "sarw"; # Your username

      # System configuration
      system = {
        # Time and locale
        timeZone = "Asia/Dhaka";
        locale = {
          default = "en_US.UTF-8";
          extra = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
          };
        };
        keyMap = "us";
        stateVersion = "24.05";
      };
    };
  };
}
