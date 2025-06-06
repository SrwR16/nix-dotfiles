{
  pkgs,
  defaults,
  config,
  ...
}: {
  # AutoFirma is disabled as it's not needed for non spanish users
  # and currently has build issues with the preferences.json file

  # programs.autofirma = {
  #   enable = true;
  #   firefoxIntegration.profiles = {
  #     "${defaults.username}" = {
  #       enable = true;
  #     };
  #   };
  # };

  # programs.dnieremote = {
  #   enable = true;
  # };

  # programs.configuradorfnmt = {
  #   enable = true;
  #   firefoxIntegration.profiles = {
  #     "${defaults.username}" = {
  #       enable = true;
  #     };
  #   };
  # };

  # programs.firefox = {
  #   policies = {
  #     SecurityDevices = {
  #       "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
  #       "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
  #     };
  #   };
  # };
}
