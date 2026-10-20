{ pkgs, pkgs-thirdParty, ... }:

{
  home.packages = [
    pkgs.unityhub
    pkgs-thirdParty.tuanjiehub
  ];
}
