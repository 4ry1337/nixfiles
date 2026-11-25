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
      sessionVariables = {
        # WLR_NO_HARDWARE_CURSOR = "1";
        NIXOS_OZONE_WL = "1";
      };
      systemPackages = [ pkgs.networkmanagerapplet ];
    };
  };
}
