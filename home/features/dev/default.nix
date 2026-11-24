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
    # common dev sub-features — override per host with `= false`
    features.dev.ai.claude-code.enable = mkDefault true;
    features.dev.ai.codex.enable = mkDefault true;

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
