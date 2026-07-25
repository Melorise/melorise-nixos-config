{ pkgs, pkgs-unstable, pkgs-thirdParty, ... }:

{

  nix.settings = {
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];

    extra-substituters = [
      "https://melorise-codex-desktop.cachix.org"
      "https://melorise-cp-nix.cachix.org"
    ];

    extra-trusted-public-keys = [
      "melorise-codex-desktop.cachix.org-1:PN32aGXkz7tWwvCuwQfKo3/P/dOG/oa8mS8y58pdB5U="
      "melorise-cp-nix.cachix.org-1:GNg96VizkktTdGMrvl6+PLPHY3jPce4a72HqP2cj4S4="
    ];
  };

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
