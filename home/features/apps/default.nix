{ lib, pkgs, ... }: {
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

  home.packages =
    with pkgs;
    [
      obsidian
      spotify
      telegram-desktop
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ nautilus ];
}
