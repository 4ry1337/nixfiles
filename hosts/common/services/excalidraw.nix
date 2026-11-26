{ config, lib, ... }:
let
  cfg = config.features.services.excalidraw;
in
{
  options.features.services.excalidraw.enable =
    lib.mkEnableOption "Excalidraw whiteboard on port 3210, reachable over the tailnet";

  config = lib.mkIf cfg.enable {
    # Static frontend (nginx serving the SPA on :80).
    # Drawings persist in each browser's localStorage, so the container keeps no data.
    # Upstream publishes only "latest" for current builds, so the digest is the pin.
    features.containers.excalidraw = {
      image = "docker.io/excalidraw/excalidraw:latest@sha256:f7ee194addd607bf831d2af0f0a34463dd4225e426cf35199ef0b12a803398e9";
      ports = [ "3210:80" ];
    };
  };
}
