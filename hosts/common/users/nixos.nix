{ pkgs, ... }:
{
  imports = [ ./rakhat.nix ];

  users.users.rakhat = {
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
  };

  console = {
    useXkbConfig = true;
    font = "spleen-16x32";
    packages = [ pkgs.spleen ];
  };
}
