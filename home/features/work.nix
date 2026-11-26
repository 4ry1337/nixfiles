{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.work;
  openconnect = getExe pkgs.openconnect;
  vpnPidFile = "/tmp/erg-vpn.pid";
in
{
  options.features.work.enable = mkEnableOption "corporate (ERG) work tools";

  config = mkIf cfg.enable (mkMerge [
    # RDP
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [ pkgs.remmina ];
    })
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      features.macos.casks = [ "windows-app" ];
    })

    # VPN (egvpn.erg.kz) via openconnect, AnyConnect protocol.
    #
    # The server requires a client certificate: ~/.config/erg-vpn/RaYs.pfx
    # (chmod 600, kept out of git). Passwords live in the macOS Keychain:
    #   security add-generic-password -s erg-vpn     -a "$USER" -w   # ERG login password
    #   security add-generic-password -s erg-vpn-pfx -a "$USER" -w   # .pfx password
    # The login password rotates every 3 months; update it in place (no rebuild):
    #   security add-generic-password -U -s erg-vpn -a "$USER" -w
    #
    # TODO(ary): untested on Linux. There is no `security` there; store the
    # passwords in the GNOME keyring and read them with `secret-tool lookup`:
    #   secret-tool store --label="ERG VPN"     service erg-vpn
    #   secret-tool store --label="ERG VPN pfx" service erg-vpn-pfx
    # The .pfx could be shared via agenix (home-manager module; recipients
    # rakhat, orange-m4, ary only) if ERG policy allows copying it. Never
    # commit the passwords: the repo is public and the login one rotates.
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "erg-vpn-up";
          text = ''
            security find-generic-password -s erg-vpn -a "$USER" -w |
              sudo ${openconnect} egvpn.erg.kz \
                --servercert pin-sha256:yyxqCpjT44wMsR9naEESr+emGPtv857YXpMB2mERveU= \
                -c "$HOME/.config/erg-vpn/RaYs.pfx" \
                -p "$(security find-generic-password -s erg-vpn-pfx -a "$USER" -w)" \
                --authgroup ERG-VPN-Profile \
                -u rakhat.yskak@erg.kz \
                --passwd-on-stdin \
                -b --pid-file=${vpnPidFile}
          '';
        })
        (pkgs.writeShellApplication {
          name = "erg-vpn-down";
          text = ''sudo kill -INT "$(cat ${vpnPidFile})"'';
        })
      ];
    })
  ]);
}
