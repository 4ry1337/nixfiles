{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openmoji-color
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];
}
