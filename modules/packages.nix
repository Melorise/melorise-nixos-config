{ pkgs, pkgs-unstable, ... }:

{

  nix.settings = {
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];

    extra-substituters = [
      "https://melorise-codex-desktop.cachix.org"
    ];

    extra-trusted-public-keys = [
      "melorise-codex-desktop.cachix.org-1:PN32aGXkz7tWwvCuwQfKo3/P/dOG/oa8mS8y58pdB5U="
    ];
  };

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
