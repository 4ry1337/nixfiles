{ inputs, ... }:
{
  imports = [
    ./.
    ./users/macos.nix
    inputs.home-manager.darwinModules.home-manager
  ];
}
