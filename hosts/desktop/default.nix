{...} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./hardware.nix
      # ./nvidia.nix  # Commented out for Intel graphics - uncomment for NVIDIA
      ./services.nix
    ]
    ++ (listNixModulesRecusive ./containers)
    ++ (listNixModulesRecusive ../../modules/nixos);

  # hostname and stateVersion are set dynamically by flake.nix
  nix.settings.system-features = [
    "kvm"
    "big-parallel"
    "gccarch-rocketlake"
    "gccarch-x86-64-v3"
    "gccarch-x86-64-v4"
  ];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
    config = {
      # cudaSupport = true;  # Commented out for Intel graphics - uncomment for NVIDIA
    };
  };
}
