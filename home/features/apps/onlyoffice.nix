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

  # macOS: installed by hosts/common/macos/homebrew.nix
  config = mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
    home.packages = [ pkgs.onlyoffice-desktopeditors ];
  };
}
