{ ... }:

{

  networking.hostName = "tippy-nix"; # Define your hostname.
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix

    ../../modules/hardware/networking.nix
    ../../modules/desktops/locale.nix
    ../../modules/desktops/fonts.nix
    ../../modules/desktops/cinnamon.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/filesystems.nix
    ../../modules/configs/docker.nix
    ../../modules/configs/gc.nix
    ../../modules/hardware/zram.nix
    ../../modules/users/tippy.nix
    ../../modules/packages/default.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "tippy"
    ];
  };

  system.stateVersion = "26.05";
}
