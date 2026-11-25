_: {
  imports = [
    ./home.nix
    ./dotfiles
    ../common
    ../features/apps
    ../features/cli
    ../features/desktop/linux
    ../features/dev
    ../features/gaming
  ];
  features = {
    dev = {
      enable = true;
      ai.claude-code.enable = true;
      ai.codex.enable = false;
      ai.markitdown.enable = true;
      # mobile.adb.enable = true;
    };
    apps = {
      onlyoffice.enable = true;
      viewers.enable = true;
      vlc.enable = true;
      obs.enable = true;
      tools.dua.enable = true;
      terminal.alacritty = {
        enable = true;
        theme = "tokyo_night";
      };
      browser.google-chrome.enable = true;
    };
    cli = {
      disk.enable = true;
      network.enable = true;
      eza.enable = true;
      fzf.enable = true;
      git.enable = true;
      neovim.enable = true;
      oh-my-posh.enable = true;
      tmux.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
    desktop = {
      hyprland.enable = true;
    };
  };
}
