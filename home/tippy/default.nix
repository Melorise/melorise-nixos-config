{ pkgs, ... }:

{
  home.username = "tippy";
  home.homeDirectory = "/home/tippy";

  home.stateVersion = "26.05";
  

  imports = [
    ./ssh.nix
    ./git.nix
    ./nodejs.nix
    ./packages.nix
    ./packages-unstable.nix
    ./ai-agent.nix
  ];

}
