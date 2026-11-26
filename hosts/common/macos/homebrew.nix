{
  config,
  inputs,
  ...
}:
let
  user = config.system.primaryUser;
in
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  # installs Homebrew itself
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  # apps nixpkgs does not build for macOS; each feature module adds its own
  homebrew = {
    enable = true;
    inherit (config.home-manager.users.${user}.features.macos) casks;
  };
}
