{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.apps.browser;
in
{
  options.features.desktop.apps.browser = {
    google-chrome.enable = mkEnableOption "Enable google-chrome application";
  };

  config = mkIf (config.features.desktop.enable && cfg.google-chrome.enable) {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
