{ config, lib, ... }:
let
  cfg = config.features.power;
in
{
  options.features.power.enable = lib.mkEnableOption "UPower";

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
  };
}
