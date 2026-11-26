{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./onlyoffice.nix
    ./viewers.nix
    ./vlc.nix
    ./tools.nix
    ./obs.nix
    ./blender.nix
    ./terminal.nix
    ./browser.nix
  ];

  config = lib.mkIf config.features.desktop.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          obsidian
          spotify
          telegram-desktop
        ];
      }
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        home.packages = [ pkgs.nautilus ];

        xdg.mimeApps = {
          enable = true;
          defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
        };
      })
    ]
  );
}
