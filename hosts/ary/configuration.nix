# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  networking.hostName = "ary";

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  features = {
    audio.enable = true;
    bluetooth.enable = true;
    dns.enable = true;
    hyprland.enable = true;
    nvidia.enable = true;
    podman.enable = true;
    power.enable = true;
    tailscale.enable = true;
    services.dbx-web.enable = true;
  };

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/862266B32266A7BF";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=${toString config.users.users.${config.features.primaryUser}.uid}"
      "gid=${toString config.users.groups.users.gid}"
      "windows_names"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
