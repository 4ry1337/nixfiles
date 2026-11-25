{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.vlc;
in
{
  options.features.apps.vlc.enable = mkEnableOption "VLC media player";

  config = mkIf cfg.enable {
    # nixpkgs builds vlc for Linux only; vlc-bin repackages the macOS release
    home.packages = [ (if pkgs.stdenv.hostPlatform.isDarwin then pkgs.vlc-bin else pkgs.vlc) ];
  };
}
