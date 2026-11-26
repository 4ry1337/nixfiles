{ lib, _class, ... }:
{
  # Only SSH keys are accepted, which prevents brute-force attacks. Make sure your
  # key is in users.users.<primary user>.openssh.authorizedKeys.keys before switching.
  services.openssh = {
    enable = true;
  }
  // lib.optionalAttrs (_class == "nixos") {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  }
  // lib.optionalAttrs (_class == "darwin") {
    extraConfig = ''
      PermitRootLogin no
      PasswordAuthentication no
      # macOS enables PAM, which can still ask for a password this way
      KbdInteractiveAuthentication no
    '';
  };
}
