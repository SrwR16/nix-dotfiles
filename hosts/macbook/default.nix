{
  pkgs,
  config,
  ...
} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;

  system = "x86_64-linux";
  apple-ib-drv =
    pkgs.callPackage ./_apple-ib-drv.nix
    {
      kernel = config.boot.kernelPackages.kernel;
    };
in {
  imports =
    [
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  # hostname is set dynamically by flake.nix when using dynamic configuration
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
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.extraModprobeConfig = ''
    options hid-appletb-kbd mode=0
  '';

  system.stateVersion = "24.11";

  # https://bugzilla.kernel.org/show_bug.cgi?id=193121
  # ccode=0,regrev=0
  # brcmfmac43602-pcie.bin

  environment.systemPackages = [
    apple-ib-drv
    (
      pkgs.stdenv.mkDerivation {
        name = "brcmfmac43602-pcie.txt";
        phases = ["installPhase"];
        installPhase = ''
          mkdir -p $out/lib/firmware/brcm
          cp ${./brcmfmac43602-pcie.txt} $out/lib/firmware/brcm/
        '';
      }
    )
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [apple-ib-drv];
  boot.initrd.kernelModules = ["apple-ibridge" "apple-touchbar" "usb_storage"];
}
