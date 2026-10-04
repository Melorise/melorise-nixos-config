{ ... }:

{
  imports = [
    ../../users/nixos.nix
    ../../modules/config/zsh.nix
    ../../modules/development/ssh.nix
    ../../modules/development/git.nix
    ../../modules/development/python.nix
    ../../modules/development/rust.nix
    ../../modules/development/ai/claude-code.nix
    ../../modules/development/ai/codex.nix
    ../../modules/development/ai/opencode.nix
    ../../modules/packages/cli.nix
  ];
}
