{ ... }:

{
  networking.hostName = "tippy-wsl";

  wsl = {
    enable = true;
    defaultUser = "tippy";
  };

  imports = [
    ../../modules/hardware/gc.nix
    ../../modules/server/docker.nix
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
