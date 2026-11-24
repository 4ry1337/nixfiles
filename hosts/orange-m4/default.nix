{ inputs, pkgs, ... }:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  networking.hostName = "orange-m4";

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users."4ry".home = "/Users/4ry";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "bak";
    users."4ry" = import ../../home/rakhat/orange-m4.nix;
  };

  fonts.packages = [ pkgs.nerd-fonts.iosevka-term ];

  programs.zsh.enable = true;

  system.stateVersion = 7;
}
