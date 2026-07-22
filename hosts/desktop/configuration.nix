{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/desktop-cinnamon.nix
    ../../modules/audio.nix
    ../../modules/users-tippy.nix
    ../../modules/packages.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
