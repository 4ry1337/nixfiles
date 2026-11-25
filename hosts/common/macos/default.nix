{ inputs, ... }:
{
  imports = [
    ../default.nix
    ./homebrew.nix
    inputs.home-manager.darwinModules.home-manager
  ];
}
