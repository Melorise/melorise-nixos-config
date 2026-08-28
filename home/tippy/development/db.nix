{ pkgs, ... }:

{
  home.packages = with pkgs; [
    dbx
  ];
}
