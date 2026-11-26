{
  networking.hostName = "orange-m4";

  nixpkgs.hostPlatform = "aarch64-darwin";

  features = {
    podman.enable = true;
    tailscale.enable = true;
    services.dbx-web.enable = true;
  };

  system.stateVersion = 7;
}
