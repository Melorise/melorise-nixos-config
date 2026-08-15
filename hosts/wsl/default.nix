{ ... }:

{
  networking.hostName = "nixos-wsl";

  wsl = {
    enable = true;
    defaultUser = "nixos";
  };

  imports = [
    ../../modules/hardware/gc.nix
    ../../modules/server/docker.nix
    ../../modules/users/nixos.nix
    ../../modules/packages/default.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "nixos"
    ];
  };

  system.stateVersion = "26.05";
}
