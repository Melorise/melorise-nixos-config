{ ... }:

{

  networking.hostName = "tippy-nix"; # Define your hostname.
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  imports = [
    ./hardware-configuration.nix

    ../../modules/networking/physical.nix
    ../../modules/desktop/locale.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/cinnamon.nix
    ../../modules/hardware/audio.nix
    ../../modules/storage/ntfs.nix
    ../../modules/storage/zram.nix
    ../../modules/services/docker.nix
    ../../modules/nix/settings.nix
    ../../modules/nix/gc.nix
    ../../modules/users/tippy.nix
    ../../modules/packages/base.nix
    ../../modules/packages/development.nix
    ../../modules/packages/mission-center.nix
    ../../modules/programs/direnv.nix
    ../../modules/programs/appimage.nix
    ../../modules/programs/linyaps.nix
    ../../modules/programs/steam.nix
    ../../modules/programs/tama-asr.nix
    ../../modules/programs/clash.nix
  ];

  nix.settings.trusted-users = [
    "root"
    "tippy"
  ];

  system.stateVersion = "26.05";
}
