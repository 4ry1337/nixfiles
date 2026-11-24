{ pkgs, ... }: {
  imports = [
    ./hyprland
    ./windows-dirs.nix
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-application-prefer-dark-theme = true;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };

  # FONTS
  home.packages = with pkgs; [
    openmoji-color
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];
}
