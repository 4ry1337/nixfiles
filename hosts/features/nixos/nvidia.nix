{ config, lib, ... }:
let
  cfg = config.features.nvidia;
in
{
  options.features.nvidia.enable = lib.mkEnableOption "NVIDIA PRIME sync";

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;

    hardware.nvidia.prime = {
      offload.enable = lib.mkForce false;
      offload.enableOffloadCmd = lib.mkForce false;
      sync.enable = lib.mkForce true;
    };
  };
}
