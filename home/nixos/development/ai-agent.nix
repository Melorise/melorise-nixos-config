{ pkgs-unstable, ... }:

{
  home.packages = with pkgs-unstable; [
    claude-code
    codex
    opencode
    cc-switch
  ];
}
