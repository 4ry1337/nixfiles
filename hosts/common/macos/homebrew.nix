{
  config,
  lib,
  inputs,
  ...
}:
let
  user = config.system.primaryUser;
  inherit (config.home-manager.users.${user}.features) apps;
in
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  # installs Homebrew itself
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  # apps nixpkgs does not build for macOS
  homebrew = {
    enable = true;
    casks = lib.optional apps.onlyoffice.enable "onlyoffice" ++ lib.optional apps.obs.enable "obs";
  };
}
