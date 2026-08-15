{ pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
  };
}
