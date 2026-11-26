{ config, lib, ... }:
let
  cfg = config.features.services.dbx-web;
in
{
  options.features.services.dbx-web.enable =
    lib.mkEnableOption "DBX web database client on http://127.0.0.1:4224";

  config = lib.mkIf cfg.enable {
    features.containers.dbx-web = {
      image = "docker.io/t8y2/dbx:0.6.75";
      # loopback only: the client is for the primary user on this machine
      ports = [ "127.0.0.1:4224:4224" ];
      volumes = [
        "dbx-data:/app/data"
        "dbx-backups:/app/backups"
      ];
      environment = {
        # inside the container; the host side is limited by the port binding above
        DBX_BIND_ADDR = "0.0.0.0";
        DBX_PORT = "4224";
        # No login page while the host has a single user. Any local user can reach
        # the loopback port, so enable a password before adding another user.
        DBX_DISABLE_PASSWORD = "1";
      };
    };
  };
}
