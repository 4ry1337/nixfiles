{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) hostPlatform;
in
{
  # Only SSH keys are accepted, which prevents brute-force attacks. Make sure your
  # key is in users.users.rakhat.openssh.authorizedKeys.keys before switching.
  services.openssh = {
    enable = true;
  }
  // lib.optionalAttrs hostPlatform.isLinux {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  }
  // lib.optionalAttrs hostPlatform.isDarwin {
    extraConfig = ''
      PermitRootLogin no
      PasswordAuthentication no
      # macOS enables PAM, which can still ask for a password this way
      KbdInteractiveAuthentication no
    '';
  };
}
