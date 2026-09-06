{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fastfetch
    file
    which
    unzip
    zip
  ];
}
