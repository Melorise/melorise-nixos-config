{ pkgs, pkgs-unstable, ... }:

{

  nix.settings.substituters = [
    "https://mirrors.cernet.edu.cn/nix-channels/store"
  ];

  nixpkgs.config.allowUnfree = true;
  
  #firefox
  #programs.firefox.enable = true;
  
  #clash-verge-rev
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    serviceMode = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];
 
  
}
