{
  networking.hostName = "orange-m4";

  nixpkgs.hostPlatform = "aarch64-darwin";

  features = {
    podman.enable = true;
    tailscale.enable = true;
  };

  homebrew = {
    brews = [ "mas" ];
    masApps."Cisco Secure Client" = 1135064690;
  };

  system.stateVersion = 7;
}
