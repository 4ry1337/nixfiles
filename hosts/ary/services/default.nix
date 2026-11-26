# Services that only this host runs.
#
# Shared services live in hosts/common/services; enable one in configuration.nix
# with `features.services.<name>.enable = true;`.
#
# To add a service for this host only, create ./<name>.nix and list it in imports.
# A container service declares features.containers.<name>
# (contract and checks: hosts/features/containers.nix):
#
#   features.containers.echo = {
#     image = "docker.io/hashicorp/http-echo:1.0.0"; # registry host + pinned tag or digest
#     ports = [ "5678:5678" ];                        # reachable over the tailnet
#     volumes = [ "echo-data:/data" ];                # named volumes only
#     cmd = [ "-text=Hello" ];                        # arguments for the image's program
#   };
{
  imports = [ ];
}
