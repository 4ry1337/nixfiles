_: {
  imports = [
    ./home.nix
    ./dotfiles
    ../common
    ../features/apps
    ../features/cli
    ../features/desktop/macos
    ../features/dev
  ];
  features = {
    dev.ai.claude-code.enable = true;
    apps.terminal.alacritty = {
      enable = true;
      theme = "tokyo_night";
    };
    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
    };
  };
}
