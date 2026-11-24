{
  imports = [
    ./dotfiles
    ../features/apps/terminal.nix
    ../features/cli/git.nix
    ../features/cli/neovim.nix
    ../features/cli/tmux.nix
    ../features/dev/ai.nix
  ];

  features = {
    apps.terminal.alacritty.enable = true;
    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
    };
    dev.ai.claude-code.enable = true;
  };

  # tmux binds Alt-h/Alt-l, but macOS types symbols with Option by default
  programs.alacritty.settings.window.option_as_alt = "Both";

  home.stateVersion = "26.05";
}
