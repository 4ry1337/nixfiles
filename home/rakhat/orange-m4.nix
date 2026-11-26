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
    dev = {
      enable = true;
      ai = {
        claude-code.enable = true;
        markitdown.enable = true;
      };
    };
    apps = {
      rdp.enable = true;
      onlyoffice.enable = true;
      obs.enable = true;
      vlc.enable = true;
      blender.enable = true;
      terminal.alacritty = {
        enable = true;
        theme = "tokyo_night";
      };
      browser.google-chrome.enable = true;
    };
    cli = {
      network.enable = true;
      disk.enable = true;
      eza.enable = true;
      fzf.enable = true;
      git.enable = true;
      neovim.enable = true;
      oh-my-posh.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
  };
}
