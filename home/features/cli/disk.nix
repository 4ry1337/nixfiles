{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cli.disk;
in
{
  options.features.cli.disk.enable = mkEnableOption "disk management tools";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        # archives
        unzip

        # disk usage
        dust

        # disk health
        smartmontools

        # sync
        # rsync
      ]
      ++ optionals stdenv.hostPlatform.isLinux [
        # disk health
        nvme-cli
      ];
  };
}
