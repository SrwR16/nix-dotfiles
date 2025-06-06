{
  defaults,
  config,
  pkgs,
  ...
}: let
  default-irs = "MaxxAudio Pro 128K MP3 4.Music w MaxxSpace";
  irs = pkgs.runCommand "irs-files" {} ''
    mkdir -p $out
    cd $out
    ${pkgs.unzip}/bin/unzip ${./irs.zip}
  '';
in {
  xdg.configFile."easyeffects/irs/" = {
    source = irs;
    recursive = true;
  };

  dconf.settings = {
    "com/github/wwmm/easyeffects/streamoutputs/convolver" = {
      kernel-path = "${config.home.homeDirectory}/.config/easyeffects/irs/${default-irs}.irs";
    };
  };

  services = {
    easyeffects = {
      enable = true;
    };
  };
}
