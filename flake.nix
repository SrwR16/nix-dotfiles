{
  description = "kOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs";

    ollamark.url = "github:SrwR16/ollamark";
    ollamark.inputs.nixpkgs.follows = "nixpkgs";

    vibeapps.url = "github:SrwR16/vibeapps";
    vibeapps.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    globset = {
      url = "github:pdtpartners/globset";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
    nix-colors.inputs.nixpkgs-lib.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    ags.url = "github:aylur/ags";
    ags.inputs.nixpkgs.follows = "nixpkgs";

    astal-shell.url = "github:knoopx/astal-shell";
    astal-shell.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake.url = "github:knoopx/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";
    # niri-flake.inputs.niri-stable.url = "github:YaLTeR/niri/v25.05.1";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin-userstyles.url = "github:catppuccin/userstyles";
    catppuccin-userstyles.flake = false;

    firefox-gnome-theme.url = "github:rafaelmardojai/firefox-gnome-theme";
    firefox-gnome-theme.flake = false;

    betterfox.url = "github:yokoffing/BetterFox";
    betterfox.flake = false;

    adwaita-colors.url = "github:dpejoh/Adwaita-colors";
    adwaita-colors.flake = false;

    neuwaita.url = "github:RusticBard/Neuwaita";
    neuwaita.flake = false;

    # Disabled autofirma-nix as it's not needed for Bangladesh users
    # autofirma-nix.url = "github:nix-community/autofirma-nix";
    # autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    firefox-addons,
    haumea,
    home-manager,
    nixpkgs,
    stylix,
    niri-flake,
    vibeapps,
    ollamark,
    astal-shell,
    # autofirma-nix, # Disabled as not needed for Bangladesh users
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Load user configuration
    userConfig = import ./userConfig.nix;

    # Create defaults from user config for backwards compatibility
    defaults = let
      primaryUser = userConfig.users.${userConfig.primaryUser};
      originalDefaults = pkgs.callPackage ./defaults.nix inputs;
    in originalDefaults // {
      # User information
      username = userConfig.primaryUser;
      full-name = primaryUser.fullName;
      primary-email = primaryUser.email;
      password = primaryUser.name;  # Use username as password

      # System configuration
      inherit (userConfig.system) hostname;
      timeZone = primaryUser.system.timeZone;
      defaultLocale = primaryUser.system.locale.default;
      region = primaryUser.system.locale.default;
      keyMap = primaryUser.system.keyMap;

      # Additional user config
      gitKey = primaryUser.gitKey or null;
      avatar-image = primaryUser.avatar or originalDefaults.avatar-image;

      # Keep original for backwards compatibility
      userConfig = userConfig;
    };

    specialArgs =
      (nixpkgs.lib.removeAttrs inputs ["self"])
      // {
        inherit inputs;
        inherit defaults;
        inherit userConfig;
      };

    haumeaInputs = prev:
      specialArgs
      // {
        pkgs = prev;
        inherit (nixpkgs) lib;
      };

    nixosModules = [
      niri-flake.nixosModules.niri
      {
        nixpkgs.overlays =
          [
            ollamark.overlays.default
            niri-flake.overlays.niri
            astal-shell.overlays.default
            (self: super: vibeapps.packages.${system})
            (
              self: super: {firefox-addons = firefox-addons.packages.${system};}
            )
            (
              final: prev:
                haumea.lib.load {
                  src = ./pkgs;
                  loader = haumea.lib.loaders.scoped;
                  inputs =
                    haumeaInputs prev;
                }
            )
            (
              final: prev: {
                lib =
                  prev.lib.extend
                  (p: x: (haumea.lib.load {
                    src = ./lib;
                    inputs = haumeaInputs prev;
                  }));
              }
            )
            (
              final: prev:
                haumea.lib.load {
                  src = ./builders;
                  inputs = haumeaInputs prev;
                }
            )
          ]
          ++ (nixpkgs.lib.attrsets.attrValues (haumea.lib.load {
            src = ./overlays;
            loader = haumea.lib.loaders.verbatim;
          }));
      }
      stylix.nixosModules.stylix
    ];

    # Home manager configuration for regular systems
    homeManagerModule = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs // {
          # Pass the primary user's configuration
          userConfig = userConfig.users.${userConfig.primaryUser};
        };
        backupFileExtension = "bak";
        users.${defaults.username} = import ./home/default.nix;
        sharedModules = [
          vibeapps.homeManagerModules.default
          # autofirma-nix.homeManagerModules.default # Disabled
        ];
      };
    };

    # VM-specific home manager configuration (uses same dynamic approach as main system)
    vmHomeManagerModule = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = specialArgs // {
          # For VM, use the primary user's configuration
          userConfig = userConfig.users.${userConfig.primaryUser};
        };
        backupFileExtension = "bak";
        users.${defaults.username} = import ./home/default.nix;
        sharedModules = [
          vibeapps.homeManagerModules.default
          # autofirma-nix.homeManagerModules.default # Disabled
        ];
      };
    };

    vmConfiguration = nixpkgs.lib.nixosSystem {
      inherit specialArgs;
      modules =
        nixosModules
        ++ [
          home-manager.nixosModules.home-manager
          vmHomeManagerModule
          ./hosts/vm
        ];
    };
  in {
    packages.${system} = {
      default = vmConfiguration.config.system.build.vm;
      vm = vmConfiguration.config.system.build.vm;
      nfoview = pkgs.callPackage ./pkgs/nfoview.nix {inherit pkgs;};
    };

    nixosConfigurations = {
      vm = vmConfiguration;

      # Dynamic configuration based on user-config.nix
      ${userConfig.system.hostname} = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            home-manager.nixosModules.home-manager
            homeManagerModule
            ./hosts/${userConfig.system.hostType}  # Use dynamic host type
            {
              networking.hostName = userConfig.system.hostname;
              time.timeZone = userConfig.users.${userConfig.primaryUser}.system.timeZone;
              i18n.defaultLocale = userConfig.users.${userConfig.primaryUser}.system.locale.default;
              i18n.extraLocaleSettings = userConfig.users.${userConfig.primaryUser}.system.locale.extra;
              console.keyMap = userConfig.users.${userConfig.primaryUser}.system.keyMap;
              system.stateVersion = userConfig.users.${userConfig.primaryUser}.system.stateVersion;
            }
          ];
      };

      # Keep existing configurations for backwards compatibility
      macbook = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          nixosModules
          ++ [
            home-manager.nixosModules.home-manager
            homeManagerModule
            ./hosts/macbook
          ];
      };
    };

    homeConfigurations =
      # Generate dynamic home configurations for each user
      builtins.listToAttrs (
        builtins.map (userName:
          let
            user = userConfig.users.${userName};
            configName = "${userName}@${userConfig.system.hostname}";
          in {
            name = configName;
            value = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = specialArgs // {
                userConfig = user;
                inherit (user) name email fullName gitKey avatar;
              };
              modules = [
                vibeapps.homeManagerModules.default
                ./home/default.nix
              ];
            };
          }
        ) (builtins.attrNames userConfig.users)
      );
  };
}
