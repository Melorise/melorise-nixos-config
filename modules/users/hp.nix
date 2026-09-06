{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.hp = {
    isNormalUser = true;
    description = "hp";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
