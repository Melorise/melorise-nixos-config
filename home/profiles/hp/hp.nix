{ ... }:

{
  imports = [
    ../../users/hp.nix
    ../../modules/config/zsh.nix
    ../../modules/development/ssh.nix
    ../../modules/development/git.nix
    ../../modules/development/nodejs.nix
    ../../modules/development/pnpm.nix
    ../../modules/development/python.nix
    ../../modules/development/vscode.nix
    ../../modules/development/ai/claude-code.nix
    ../../modules/development/ai/codex.nix
    ../../modules/development/ai/cc-switch.nix
    ../../modules/development/ai/chatgpt.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/chrome.nix
    ../../modules/packages/qq.nix
  ];
}
