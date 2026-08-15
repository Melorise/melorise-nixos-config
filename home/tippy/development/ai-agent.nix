{ pkgs-unstable, pkgs-thirdParty, ... }:

{
  home.packages =
    (with pkgs-unstable; [
      claude-code
      codex
      opencode

      cc-switch
    ])
    ++ (with pkgs-thirdParty; [
      chatgpt
    ]);
}
