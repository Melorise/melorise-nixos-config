{ pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    google-chrome
  ];

}
