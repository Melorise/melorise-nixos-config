{ pkgs, pkgs-unstable, pkgs-thirdParty, ... }:

{

  nixpkgs.config.allowUnfree = true;
  
  #firefox
  #programs.firefox.enable = true;
  
  #clash-verge-rev
  programs.clash-verge = {
    enable = true;
    serviceMode = true;
  };

  # clash-party
  programs.clash-party = {
    enable = true;
    package = pkgs-thirdParty.clash-party;
  };
  
  # 用于自动进入开发环境的direnv
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fastfetch
  ];
 
  
}
