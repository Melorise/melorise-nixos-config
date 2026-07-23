{ pkgs, ... }:

{
  home.username = "tippy";
  home.homeDirectory = "/home/tippy";

  home.stateVersion = "26.05";
  

  imports = [
    ./development/ssh.nix
    ./development/git.nix
    ./development/nodejs.nix
    ./development/python.nix
    ./development/ai-agent.nix
    ./packages/packages.nix
    ./packages/packages-unstable.nix
  ];

}
