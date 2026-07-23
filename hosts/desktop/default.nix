{ ... }:

{

  networking.hostName = "tippy-nix"; # Define your hostname.
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix

    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/fonts.nix
    ../../modules/desktop-cinnamon.nix
    ../../modules/audio.nix
    ../../modules/gc.nix
    ../../modules/users-tippy.nix
    ../../modules/packages.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
