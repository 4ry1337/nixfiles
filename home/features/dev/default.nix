{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.dev;
in
{
  imports = [
    ./ai.nix
    ./mobile.nix
  ];

  options.features.dev.enable = mkEnableOption "development toolchain (devenv, compilers)";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        devenv
        vulkan-tools # Graphics debugging tools
      ]
      # on macOS, gcc would shadow Apple's cc
      ++ optionals stdenv.hostPlatform.isLinux [ gcc ];

    # devenv cd-activation hook — only emitted when zsh is managed
    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      eval "$(devenv hook zsh)"
    '';
  };
}
