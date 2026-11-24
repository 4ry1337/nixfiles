{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.rakhat = {
    description = "rakhat";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAw073fJwGbhBTWk6Yy2h/MTGnUJrbjnMQ8hJ0PLZGJr rakhat"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
  home-manager.users.rakhat = import ../../../home/rakhat/${config.networking.hostName}.nix;
}
