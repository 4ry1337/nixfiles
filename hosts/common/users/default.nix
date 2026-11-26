{
  config,
  lib,
  _class,
  ...
}:
{
  imports = [ ./rakhat.nix ];

  options.features.primaryUser = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    description = "Login name of the user who owns this host: trusted Nix user, owner of rootless containers and of per-user launchd jobs.";
  };

  config = lib.optionalAttrs (_class == "darwin") {
    system.primaryUser = config.features.primaryUser;
  };
}
