{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    htop

    unityhub
  ];
}
