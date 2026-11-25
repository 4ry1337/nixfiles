{
  config,
  lib,
  pkgs,
  inputs,
  _class,
  ...
}:
{
  users.users.rakhat = lib.mkMerge [
    {
      description = "rakhat";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAw073fJwGbhBTWk6Yy2h/MTGnUJrbjnMQ8hJ0PLZGJr rakhat"
      ];
      packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    }
    (lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      initialHashedPassword = "$y$j9T$IDkYUSjCVv0d7/tURzT/z0$cUeIhq8Z39jrnsMsfwmtV1SZwK3Yl1qZH/fVWOUwOg2";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "libvirtd"
        "flatpak"
        "audio"
        "video"
        "plugdev"
        "input"
        "kvm"
        "qemu-libvirtd"
      ];
    })
    (lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin { home = "/Users/rakhat"; })
  ];
  home-manager.users.rakhat = import ../../../home/rakhat/${config.networking.hostName}.nix;
}
// lib.optionalAttrs (_class == "darwin") {
  # owner of per-user launchd jobs
  system.primaryUser = "rakhat";
}
