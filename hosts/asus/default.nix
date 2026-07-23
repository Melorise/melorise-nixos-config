{ ... }:

{ 
  networking.hostName = "tippy-asus"; # Define your hostname.
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  imports = [
    ./hardware-configuration.nix

    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/desktop-cinnamon.nix
    ../../modules/audio.nix
    ../../modules/gc.nix
    ../../modules/nvidia.nix
    ../../modules/users-tippy.nix
    ../../modules/packages.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "26.05";
}
