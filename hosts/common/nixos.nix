{ inputs, ... }:
{
  imports = [
    ./.
    ./extra_services
    ./users/nixos.nix
    inputs.home-manager.nixosModules.home-manager
  ];
}
