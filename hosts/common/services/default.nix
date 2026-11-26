# Shared services, off by default. Container services declare
# features.containers; that module picks the platform backend and enables podman.
{
  imports = [
    ./dbx-web.nix
    ./excalidraw.nix
  ];
}
