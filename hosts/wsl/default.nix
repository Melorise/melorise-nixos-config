{ inputs, ... }:

{
  networking.hostName = "nixos-wsl";

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  imports = [
    inputs.nixos-wsl.nixosModules.default

    ../../modules/nix/settings.nix
    ../../modules/nix/gc.nix
    ../../modules/services/docker.nix
    ../../modules/users/nixos.nix
    ../../modules/packages/base.nix
    ../../modules/packages/development.nix
    ../../modules/programs/direnv.nix
    ../../modules/programs/nix-ld.nix
  ];

  nix.settings.trusted-users = [
    "root"
    "nixos"
  ];

  system.stateVersion = "26.05";
}
