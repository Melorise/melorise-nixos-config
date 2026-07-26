{ ... }:

{ 
  networking.hostName = "tippy-asus"; # Define your hostname.
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  imports = [
    ./hardware-configuration.nix

    ../../modules/networking.nix
    ../../modules/locale.nix
    ../../modules/fonts.nix
    ../../modules/desktop-cinnamon.nix
    ../../modules/audio.nix
    ../../modules/filesystems.nix
    ../../modules/docker.nix
    ../../modules/gc.nix
    ../../modules/nvidia.nix
    ../../modules/users-tippy.nix
    ../../modules/packages.nix
    ../../modules/spark-store.nix
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
