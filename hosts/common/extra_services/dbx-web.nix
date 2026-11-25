{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.extra_services.dbx-web;
in
{
  options.extra_services.dbx-web.enable = mkEnableOption "Enable DBX web database client on http://127.0.0.1:4224";

  config = mkIf cfg.enable {
    systemd.services.dbx-web = {
      description = "DBX web database client";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        DBX_BIND_ADDR = "127.0.0.1";
        DBX_PORT = "4224";
        DBX_DATA_DIR = "/var/lib/dbx-web";
        # Reachable from this machine only, so a login page would protect nothing.
        DBX_DISABLE_PASSWORD = "1";
      };
      serviceConfig = {
        ExecStart = getExe pkgs.dbx-web;
        DynamicUser = true;
        StateDirectory = "dbx-web";
        WorkingDirectory = "/var/lib/dbx-web";
        Restart = "on-failure";
      };
    };
  };
}
