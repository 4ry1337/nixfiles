{ pkgs, ... }:
{
  networking.hostName = "orange-m4";

  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  programs.zsh.enable = true;

  system.stateVersion = 7;
}
