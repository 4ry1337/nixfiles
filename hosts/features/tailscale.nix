{ config, lib, ... }:
let
  cfg = config.features.tailscale;
in
{
  options.features.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf cfg.enable {
    # no authKeyFile on nix-darwin: log in once with `tailscale up`
    services.tailscale.enable = true;
  };
}
