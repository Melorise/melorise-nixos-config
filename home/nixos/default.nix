{ ... }:

{
  home.username = "nixos";
  home.homeDirectory = "/home/nixos";
  home.stateVersion = "26.05";

  imports = [
    ./config/zsh.nix
    ./development/ssh.nix
    ./development/git.nix
    ./development/nodejs.nix
    ./development/python.nix
    ./development/rust.nix
    ./development/ai-agent.nix
    ./packages/packages.nix
  ];
}
