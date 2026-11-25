{ inputs, ... }:
{
  imports = [
    ../default.nix
    inputs.home-manager.darwinModules.home-manager
  ];
}
