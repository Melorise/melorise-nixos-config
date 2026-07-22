{ pkgs, ... }:

{

  nix.settings.substituters = [
    "https://mirrors.cernet.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.firefox.enable = true;

  programs.clash-verge.enable = true;
  programs.clash-verge.tunMode = true;
  programs.clash-verge.serviceMode = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];
  
  
}
