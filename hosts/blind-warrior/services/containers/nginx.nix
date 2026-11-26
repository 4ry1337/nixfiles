_: {
  # Learning container: no published port, so it is reachable only from inside podman.
  features.containers.nginx = {
    image = "docker.io/library/nginx:1.30.8-alpine";
  };
}
