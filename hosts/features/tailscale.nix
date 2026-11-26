{
  config,
  lib,
  _class,
  ...
}:
let
  cfg = config.features.tailscale;
in
{
  options.features.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # no authKeyFile on nix-darwin: log in once with `tailscale up`
      { services.tailscale.enable = true; }

      (lib.optionalAttrs (_class == "nixos") {
        age.secrets.tailscale-authkey.file = ../../secrets/tailscale-authkey.age;

        services.tailscale = {
          authKeyFile = config.age.secrets.tailscale-authkey.path;
          openFirewall = true;
          # run Tailscale's built-in SSH server (auth via the tailnet ACL policy)
          extraSetFlags = [ "--ssh" ];
        };

        # tailnet is trusted — also lets the host's services (AdGuard, DNS, containers, …)
        # be reached over tailscale0 without per-port firewall rules
        networking.firewall.trustedInterfaces = [ "tailscale0" ];
      })
    ]
  );
}
