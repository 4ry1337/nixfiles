{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.apps.onlyoffice;
in
{
  options.features.desktop.apps.onlyoffice.enable = mkEnableOption "ONLYOFFICE desktop editors";

  config = mkIf (config.features.desktop.enable && cfg.enable) (mkMerge [
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [ pkgs.onlyoffice-desktopeditors ];
    })
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      features.macos.casks = [ "onlyoffice" ];
    })
  ]);
}
