{ pkgs-unstable, codex-desktop-linux, ... }:

{
  imports = [
    codex-desktop-linux.homeManagerModules.default
  ];

  home.packages = with pkgs-unstable; [
    claude-code
    codex
    opencode

    cc-switch
  ];

  programs.codexDesktopLinux = {
    enable = true;
    cliPackage = pkgs-unstable.codex;
  };
}
