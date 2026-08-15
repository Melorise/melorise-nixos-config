{ pkgs, pkgs-unstable, pkgs-thirdParty, ... }:

{

  nix.settings = {
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];
    extra-substituters = [
      "https://melorise-cp-nix.cachix.org"
      "https://melorise-codex-desktop.cachix.org"
    ];
    trusted-public-keys = [
      "melorise-cp-nix.cachix.org-1:GNg96VizkktTdGMrvl6+PLPHY3jPce4a72HqP2cj4S4="
      "melorise-codex-desktop.cachix.org-1:PN32aGXkz7tWwvCuwQfKo3/P/dOG/oa8mS8y58pdB5U="
    ];
  };

  nixpkgs.config.allowUnfree = true;
  
  #firefox
  #programs.firefox.enable = true;

  # clash-party
  programs.clash-party = {
    enable = true;
    package = pkgs-thirdParty.clash-party;
  };

  programs.clash-verge = {
    enable = true;
    tunMode = true;
    serviceMode = true;
    package = pkgs-unstable.clash-verge-rev;
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
