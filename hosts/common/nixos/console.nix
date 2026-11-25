{ pkgs, ... }:
{
  console = {
    useXkbConfig = true;
    font = "spleen-16x32";
    packages = [ pkgs.spleen ];
  };
}
