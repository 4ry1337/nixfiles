{ config, lib, ... }:
let
  cfg = config.features.bluetooth;
in
{
  options.features.bluetooth.enable = lib.mkEnableOption "Bluetooth with blueman";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}
