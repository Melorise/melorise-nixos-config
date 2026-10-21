# 个人 NixOS 配置

这是我的个人 NixOS 配置仓库，基于 Nix Flakes 和 Home Manager 管理，基础系统使用 nixos-unstable。

本项目采用MPL V2许可证开源，请遵守许可证使用。  

建议使用AI Agent辅助管理。项目配备有完善的AGENTS.md和CLAUDE.md编码围栏。

## Node.js 环境

各设备使用 [nvm-sh/nvm](https://github.com/nvm-sh/nvm) 管理 Node.js。NVM 和 Node 版本由用户安装、更新，npm 全局包与 pnpm 也由用户管理；Home Manager 仅负责在 Zsh 中加载 `~/.nvm/nvm.sh` 和 NVM 补全。系统启用 [nix-ld](https://github.com/nix-community/nix-ld)，使用 NixOS 默认兼容库支持运行 NVM 下载的官方 Node 二进制。

先手动应用对应设备的系统配置，再重新登录，使新的 Zsh 初始化和 nix-ld 环境变量生效。已有 `~/.nvm/nvm.sh` 的设备可直接复用；尚未安装 NVM 的设备，使用以下命令首次安装：

```bash
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh \
  | NVM_DIR="$HOME/.nvm" PROFILE=/dev/null bash
```

`PROFILE=/dev/null` 让安装脚本跳过配置文件写入，避免修改 Home Manager 生成的只读 `.zshrc`。安装完成后重新打开终端，NVM 会自动加载；尚未安装时，Zsh 会跳过加载。

安装官方 Node.js 24 二进制并设置默认版本：

```bash
nvm install -b 24
nvm alias default 24
node --version
npm --version
```

新终端会使用 NVM 的默认版本。需要其他版本时，可自行运行 `nvm install -b <版本>`、`nvm use <版本>`；需要 pnpm 时，在选定的 Node 环境中运行 `npm install -g pnpm`。

原有 `NPM_CONFIG_PREFIX`、`~/.local/bin` 和 `~/.npm-global/bin` PATH 配置及 `~/.local/bin/dsh` 包装脚本不再由 Home Manager 提供。NVM 与自定义 npm prefix 不兼容；迁移时若当前终端仍有旧设置，先运行 `unset NPM_CONFIG_PREFIX npm_config_prefix PREFIX`，并自行删除 `~/.npmrc` 中的 `prefix` 设置，再加载 NVM。已有的 `~/.npm-global` 目录和其中的全局安装内容保留，所需全局包应在选定的 NVM Node 环境中重新安装，`dsh` 包装脚本由用户自行维护。

以上安装、迁移和验证命令均由用户手动执行。

## ASUS 的 AI 工具目录

ASUS 的 `tippy` Home profile 使用 Home Manager 的 `home.file` 和 `mkOutOfStoreSymlink` 管理以下整目录符号链接。配置、会话记录、凭据及其他运行数据保存在 `/data/Dev/AI`，各工具继续通过家目录中的原有入口读写。

| 家目录入口 | 实际目录 |
|---|---|
| `~/.agents` | `/data/Dev/AI/Agents/.agents` |
| `~/.claude` | `/data/Dev/AI/Claude/.claude` |
| `~/.codebuddy` | `/data/Dev/AI/Codebuddy/.codebuddy` |
| `~/.codex` | `/data/Dev/AI/Codex/.codex` |
| `~/.codely` | `/data/Dev/AI/Codely/.codely` |
| `~/.codely-cli` | `/data/Dev/AI/Codely/.codely-cli` |
| `~/.dsh` | `/data/Dev/AI/Dsh/.dsh` |

应用前应准备好表中的实际目录及其数据。已有指向相同目标的符号链接可以保留；若同名入口是普通目录或指向其他位置的链接，应退出对应工具并先手动整理数据与入口。随后执行下方“应用华硕设备配置”中的命令，由 Home Manager 建立和维护链接。

## 常用命令

以下命令需要手动执行。

### 初始化 Flake 锁文件

根据 `flake.nix` 中声明的输入创建或补充 `flake.lock`：

```bash
nix flake lock
```

### 更新 Flake 输入

将 `flake.lock` 中的输入更新到当前允许的最新版本：

```bash
nix flake update
```

### 应用台式机配置

构建并切换到 `desktop` 配置：

```bash
sudo nixos-rebuild switch --flake .#desktop
```

### 应用华硕设备配置

构建并切换到 `asus` 配置：

```bash
sudo nixos-rebuild switch --flake .#asus
```

### 应用 WSL 配置

先从 [NixOS-WSL Releases](https://github.com/nix-community/NixOS-WSL/releases/latest) 下载 `nixos.wsl`，然后在 PowerShell 中安装 WSL2 发行版：

```powershell
wsl --install --no-distribution
wsl --install --from-file .\nixos.wsl --name NixOS
```

进入 NixOS 后，将本仓库放在 WSL 文件系统中，并手动应用 `wsl` 配置。该配置使用独立的 `nixos` 用户和 `home/profiles/wsl/nixos.nix` Home Manager profile，不会安装物理机 `tippy` 配置中的 Chrome、QQ、Unity Hub 或 ChatGPT 桌面应用：

```bash
wsl -d NixOS
cd /path/to/nixos
sudo nixos-rebuild switch --flake .#wsl
```

应用完成后，可以通过 `wsl --shutdown` 后重新启动发行版，使默认用户设置生效。上述命令只作操作记录，仓库维护时不会由 agent 自动执行。
