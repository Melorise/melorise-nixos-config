{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    claude-code
    codex
    opencode

    pkgs-unstable.cc-switch
  ];

}
