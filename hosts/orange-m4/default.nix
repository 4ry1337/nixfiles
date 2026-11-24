{ pkgs, ... }:
{
  networking.hostName = "orange-m4";

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true; # claude-code
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    claude-code
    gh
    ghq
    git
  ];

  programs.zsh.enable = true; # puts system packages on zsh's PATH
  system.stateVersion = 7;
}
