{ lib, pkgs, ... }: {
  imports = [
    ./disk.nix
    ./eza.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./network.nix
    ./oh-my-posh.nix
    ./tmux.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  programs.nix-index.enable = true;

  home.packages =
    with pkgs;
    [
      btop
      fastfetch
      coreutils
      fd
      jq
      ripgrep
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wl-clipboard ];
}
