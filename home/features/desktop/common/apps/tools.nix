{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.apps.tools;
in
{
  options.features.desktop.apps.tools = {
    dua.enable = mkEnableOption "Enable baobab DUA";
  };

  config = mkIf config.features.desktop.enable (mkMerge [
    (mkIf cfg.dua.enable {
      home.packages = with pkgs; [
        baobab
      ];
    })
  ]);
}
