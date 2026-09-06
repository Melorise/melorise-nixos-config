{ ... }:

{
  networking.hostName = "tippy-hp";

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = false;
    fsIdentifier = "provided";
  };

  imports = [
    ./hardware-configuration.nix

    ../../modules/networking/physical.nix
    ../../modules/desktop/locale.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/kde.nix
    ../../modules/hardware/audio.nix
    ../../modules/storage/ntfs.nix
    ../../modules/storage/zram.nix
    ../../modules/storage/bees.nix
    ../../modules/services/docker.nix
    ../../modules/services/npanel.nix
    ../../modules/services/printing.nix
    ../../modules/nix/settings.nix
    ../../modules/nix/gc.nix
    ../../modules/users/hp.nix
    ../../modules/packages/base.nix
    ../../modules/packages/development.nix
    ../../modules/programs/direnv.nix
    ../../modules/programs/appimage.nix
    ../../modules/programs/clash.nix
  ];

  nix.settings.trusted-users = [
    "root"
    "hp"
  ];

  system.stateVersion = "26.05";
}
