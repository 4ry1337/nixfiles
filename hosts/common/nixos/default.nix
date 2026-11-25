{ inputs, ... }:
{
  imports = [
    ../default.nix
    ./console.nix
    ./fs.nix
    ./networking.nix
    ./security.nix
    ./shell.nix
    ./time_and_lang.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  programs.nix-ld.enable = true;
}
