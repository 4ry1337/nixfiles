{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common
    ./hyprland
    ./windows-dirs.nix
  ];

  config = lib.mkMerge [
    {
      # Hyprland is the only Linux graphical session.
      features.desktop.enable = config.features.desktop.hyprland.enable;

      # Base and user directories also serve CLI tools, so they stay on without a session.
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    }

    (lib.mkIf config.features.desktop.enable {
      gtk = {
        enable = true;
        gtk3.extraConfig."gtk-application-prefer-dark-theme" = true;
      };

      dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-application-prefer-dark-theme = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    })
  ];
}
