{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.hyprland;
in
{
  options.features.hyprland.enable = lib.mkEnableOption "Hyprland desktop session";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = [ pkgs.networkmanagerapplet ];
    };
  };
}
