{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.onlyoffice;
in
{
  options.features.apps.onlyoffice.enable = mkEnableOption "ONLYOFFICE desktop editors";

  config = mkIf cfg.enable (mkMerge [
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [ pkgs.onlyoffice-desktopeditors ];
    })
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      features.macos.casks = [ "onlyoffice" ];
    })
  ]);
}
