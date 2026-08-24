{ pkgs, pkgs-thirdParty, ... }:

{
  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };

  environment.systemPackages = [
    pkgs-thirdParty.meloasr
  ];
}
