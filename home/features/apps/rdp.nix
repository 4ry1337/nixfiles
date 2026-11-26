{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.rdp;
in
{
  options.features.apps.rdp.enable = mkEnableOption "Enable RDP";

  config = mkIf cfg.enable (mkMerge [
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = with pkgs; [
        remmina
      ];
    })
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      features.macos.casks = [ "windows-app" ];
    })
  ]);
}
