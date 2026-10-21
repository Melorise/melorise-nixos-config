{ config, ... }:

{
  imports = [
    ../../users/tippy.nix
    ../../modules/config/zsh.nix
    ../../modules/development/ssh.nix
    ../../modules/development/git.nix
    ../../modules/development/nvm.nix
    ../../modules/development/python.nix
    ../../modules/development/rust.nix
    ../../modules/development/vscode.nix
    ../../modules/development/unityhub.nix
    ../../modules/development/ai/claude-code.nix
    ../../modules/development/ai/codex.nix
    ../../modules/development/ai/opencode.nix
    ../../modules/development/ai/chatgpt.nix
    ../../modules/development/ai/cc-switch.nix
    ../../modules/packages/cli.nix
    ../../modules/packages/chrome.nix
    ../../modules/packages/qq.nix
  ];

  home.file = {
    ".agents".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Agents/.agents";
    ".claude".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Claude/.claude";
    ".codebuddy".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Codebuddy/.codebuddy";
    ".codex".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Codex/.codex";
    ".codely".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Codely/.codely";
    ".codely-cli".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Codely/.codely-cli";
    ".dsh".source = config.lib.file.mkOutOfStoreSymlink "/data/Dev/AI/Dsh/.dsh";
  };
}
