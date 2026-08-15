{ pkgs-unstable, pkgs-thirdParty, ... }:

{
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
}
