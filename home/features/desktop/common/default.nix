{ lib, ... }:
{
  imports = [
    ./apps
    ./fonts.nix
  ];

  # Derived, not chosen: desktop/linux and desktop/macos set it from the
  # session they provide, so GUI modules cannot turn on without one.
  # No default: importing common without a platform module is an error.
  options.features.desktop.enable = lib.mkOption {
    type = lib.types.bool;
    readOnly = true;
    description = "Whether a graphical session is available. Set by the platform desktop module.";
  };
}
