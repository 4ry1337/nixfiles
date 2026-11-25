{
  config,
  lib,
  pkgs,
  _class,
  ...
}:
let
  cfg = config.features.podman;
  pruneFlags = [
    "--filter=until=24h"
    "--filter=label!=important"
  ];
in
{
  options.features.podman.enable = lib.mkEnableOption "Podman with Docker compatibility";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      { environment.systemPackages = [ pkgs.podman-compose ]; }

      (lib.optionalAttrs (_class == "nixos") {
        virtualisation = {
          podman = {
            enable = true;
            dockerCompat = true;
            autoPrune = {
              enable = true;
              dates = "weekly";
              flags = pruneFlags;
            };
            defaultNetwork.settings.dns_enabled = false;
          };
          containers.registries.settings.unqualified-search-registries = [ "docker.io" ];
        };
      })

      # registries and DNS are left to the podman VM, whose defaults match the above
      (lib.optionalAttrs (_class == "darwin") {
        environment.systemPackages = [
          pkgs.podman
          (pkgs.runCommand "podman-docker-compat" { } ''
            mkdir -p $out/bin
            ln -s ${lib.getExe pkgs.podman} $out/bin/docker
          '')
        ];

        launchd.user.agents.podman-prune.serviceConfig = {
          ProgramArguments = [
            (lib.getExe pkgs.podman)
            "system"
            "prune"
            "--force"
          ]
          ++ pruneFlags;
          StartCalendarInterval = [
            {
              Weekday = 1;
              Hour = 0;
              Minute = 0;
            }
          ];
        };
      })
    ]
  );
}
