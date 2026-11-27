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

  # Output format: `go help goauth`. Go also calls it with a URL after a 4xx; the answer is the same.
  ergGoAuth = pkgs.writeShellApplication {
    name = "erg-go-auth";
    runtimeInputs = [
      config.programs.git.package
      pkgs.coreutils
    ];
    text = ''
      credential=$(printf 'protocol=https\nhost=gitlab.erg.kz\n\n' | GIT_TERMINAL_PROMPT=0 git credential fill)
      username=$(sed -n 's/^username=//p' <<<"$credential")
      password=$(sed -n 's/^password=//p' <<<"$credential")
      printf 'https://gitlab.erg.kz\n\nAuthorization: Basic %s\n\n' \
        "$(printf '%s:%s' "$username" "$password" | base64 -w0)"
    '';
  };
in
{
  options.features.work.enable = mkEnableOption "corporate (ERG) work tools";

  config = mkIf cfg.enable (mkMerge [
    # RDP
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      home.packages = [ pkgs.remmina ];
    })
    (mkIf pkgs.stdenv.hostPlatform.isDarwin {
      features.macos.casks = [
        "windows-app"
        "microsoft-outlook"
      ];
    })

    # nix git checks its own CA bundle, not the macOS Keychain.
    # ghq treats the first two path segments as the repo; vcs=git makes it use the full URL (GitLab subgroups).
    {
      programs.git.settings = {
        http."https://gitlab.erg.kz/".sslCAInfo = "${./erg-ca.pem}";
        ghq."https://gitlab.erg.kz/".vcs = "git";
      };
    }

    # Private Go modules on gitlab.erg.kz.
    #
    # Without auth, GitLab answers go-get for subgroup modules with 200 and the wrong
    # repo (qollab-mobile/services.git). GOAUTH=git does not help: Go runs it only
    # after a 4xx. A GOAUTH command runs before the first request, so it sends the
    # git credential (osxkeychain) at once. GOPRIVATE also sets the defaults of
    # GONOPROXY and GONOSUMDB.
    #
    # Only the env file is written; each project gets its Go from devenv.
    # Home Manager owns the env file, so `go env -w` fails.
    #
    # If GitLab refuses the Keychain credential, store a read_api + read_repository
    # token. Type the lines below on stdin (not as arguments) to keep the token
    # out of shell history:
    #   git credential approve
    #   protocol=https
    #   host=gitlab.erg.kz
    #   username=rakhat.yskak
    #   password=<token>
    #   <empty line>
    {
      programs.go = {
        enable = true;
        package = null;
        env = {
          GOPRIVATE = "gitlab.erg.kz";
          GOAUTH = getExe ergGoAuth;
        };
      };
    }

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
