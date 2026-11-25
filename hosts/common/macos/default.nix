{ inputs, ... }:
{
  imports = [
    ../default.nix
    inputs.home-manager.darwinModules.home-manager
  ];

  # owner of per-user launchd jobs
  system.primaryUser = "rakhat";
}
