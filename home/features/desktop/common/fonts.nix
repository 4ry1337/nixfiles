{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.features.desktop.enable {
    home.packages = with pkgs; [
      openmoji-color
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
    ];
  };
}
