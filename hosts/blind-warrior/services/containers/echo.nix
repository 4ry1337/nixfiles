_: {
  # HTTP test service: answers every request with the text below.
  features.containers.echo-http-service = {
    image = "docker.io/hashicorp/http-echo:1.0.0";
    ports = [ "5678:5678" ];
    cmd = [ "-text=Hello, World!" ];
  };
}
