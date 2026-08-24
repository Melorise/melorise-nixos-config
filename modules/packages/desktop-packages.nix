{ pkgs-thirdParty, ... }:

{
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs-thirdParty.meloasr
  ];
}
