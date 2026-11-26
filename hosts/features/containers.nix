{
  config,
  lib,
  pkgs,
  _class,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = config.features.containers;
  owner = config.features.primaryUser;
  podman = lib.getExe pkgs.podman;

  segments = image: lib.splitString "/" image;

  # registry host first, so the image does not depend on unqualified-search-registries;
  # same rule as the Docker reference grammar: a dot, a port, or "localhost"
  hasRegistry =
    image:
    let
      first = lib.head (segments image);
    in
    lib.length (segments image) >= 2
    && (lib.hasInfix "." first || lib.hasInfix ":" first || first == "localhost");

  # a digest, or a tag other than "latest", so a pull cannot change the container silently
  isPinned =
    image:
    let
      nameAndTag = lib.splitString ":" (lib.last (segments image));
    in
    lib.hasInfix "@sha256:" image
    || (lib.length nameAndTag == 2 && lib.elemAt nameAndTag 1 != "latest");

  # named volumes keep data in the owner's podman storage on every platform
  isHostPath =
    volume:
    let
      source = lib.head (lib.splitString ":" volume);
    in
    lib.hasPrefix "/" source || lib.hasPrefix "." source || lib.hasPrefix "~" source;

  containerOptions = {
    options = {
      image = mkOption {
        type = types.str;
        example = "docker.io/library/nginx:1.30.8-alpine";
        description = "Image with registry host, pinned to a tag other than latest or to a digest.";
      };
      ports = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "127.0.0.1:8080:80" ];
        description = "Published ports, in podman `--publish` syntax.";
      };
      volumes = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "data:/var/lib/app" ];
        description = "Named volumes only, as `name:/path/in/container[:options]`.";
      };
      environment = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Environment variables inside the container.";
      };
      cmd = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Arguments that replace the image's default command.";
      };
    };
  };

  assertionsFor =
    name: container:
    [
      {
        assertion = hasRegistry container.image;
        message = "features.containers.${name}.image: \"${container.image}\" must start with a registry host, e.g. docker.io/.";
      }
      {
        assertion = isPinned container.image;
        message = "features.containers.${name}.image: pin a tag other than latest, or a digest.";
      }
    ]
    ++ map (volume: {
      assertion = !isHostPath volume;
      message = "features.containers.${name}.volumes: \"${volume}\" is a host path; use a named volume.";
    }) container.volumes;

  runArgs =
    name: container:
    [
      "run"
      "--rm"
      "--replace"
      "--name=${name}"
    ]
    ++ map (port: "--publish=${port}") container.ports
    ++ map (volume: "--volume=${volume}") container.volumes
    ++ lib.mapAttrsToList (key: value: "--env=${key}=${value}") container.environment
    ++ [ container.image ]
    ++ container.cmd;

  darwinLog = name: "${config.users.users.${owner}.home}/Library/Logs/${name}.log";
in
{
  options.features.containers = mkOption {
    type = types.attrsOf (types.submodule containerOptions);
    default = { };
    description = "Rootless containers owned by features.primaryUser. Each platform runs them with its own backend.";
  };

  config = lib.mkIf (cfg != { }) (
    lib.mkMerge [
      {
        assertions = lib.concatLists (lib.mapAttrsToList assertionsFor cfg);

        features.podman.enable = true;
      }

      (lib.optionalAttrs (_class == "nixos") {
        # rootless containers need the owner's user manager running without a login
        users.users.${owner}.linger = true;

        virtualisation.oci-containers.containers = lib.mapAttrs (_: container: {
          inherit (container)
            image
            ports
            volumes
            environment
            cmd
            ;
          podman.user = owner;
        }) cfg;
      })

      # containers run in the owner's podman VM; on sleep macOS freezes the VM, on wake they continue
      (lib.optionalAttrs (_class == "darwin") {
        launchd.user.agents = {
          podman-machine = {
            script = ''
              ${podman} machine inspect >/dev/null 2>&1 || ${podman} machine init
              if [ "$(${podman} machine inspect --format '{{.State}}')" != running ]; then
                exec ${podman} machine start
              fi
            '';
            serviceConfig = {
              RunAtLoad = true;
              StandardOutPath = darwinLog "podman-machine";
              StandardErrorPath = darwinLog "podman-machine";
            };
          };
        }
        // lib.mapAttrs' (
          name: container:
          lib.nameValuePair "podman-${name}" {
            # launchd has no start order, so each container waits for the VM itself
            script = ''
              until ${podman} info >/dev/null 2>&1; do sleep 5; done
              exec ${podman} ${lib.escapeShellArgs (runArgs name container)}
            '';
            serviceConfig = {
              RunAtLoad = true;
              KeepAlive = true;
              ThrottleInterval = 10;
              StandardOutPath = darwinLog "podman-${name}";
              StandardErrorPath = darwinLog "podman-${name}";
            };
          }
        ) cfg;
      })
    ]
  );
}
