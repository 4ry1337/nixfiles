{
  config,
  lib,
  pkgs,
  inputs,
  _class,
  ...
}:
let
  name = "rakhat";
in
{
  features.primaryUser = name;

  users.users.${name} = lib.mkMerge [
    {
      description = name;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAw073fJwGbhBTWk6Yy2h/MTGnUJrbjnMQ8hJ0PLZGJr rakhat"
      ];
      packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
    }
    (lib.optionalAttrs (_class == "nixos") {
      # static, so mounts and rootless containers can refer to it
      uid = 1000;
      initialHashedPassword = "$y$j9T$IDkYUSjCVv0d7/tURzT/z0$cUeIhq8Z39jrnsMsfwmtV1SZwK3Yl1qZH/fVWOUwOg2";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "kvm"
      ];
    })
    (lib.optionalAttrs (_class == "darwin") { home = "/Users/${name}"; })
  ];

  home-manager.users.${name} = import ../../../home/rakhat/${config.networking.hostName}.nix;
}
