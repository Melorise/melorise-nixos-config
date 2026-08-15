# 个人 NixOS 配置

这是我的个人 NixOS 配置仓库，基于 Nix Flakes 和 Home Manager 管理，当前使用 NixOS 26.05。

本项目采用MPL V2许可证开源，请遵守许可证使用。  

建议使用AI Agent辅助管理。项目配备有完善的AGENTS.md和CLAUDE.md编码围栏。

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

进入 NixOS 后，将本仓库放在 WSL 文件系统中，并手动应用 `wsl` 配置。该配置使用独立的 `nixos` 用户和 `home/nixos` Home Manager 配置，不会安装物理机 `tippy` 配置中的 Chrome、QQ、Unity Hub 或 ChatGPT 桌面应用：

```bash
wsl -d NixOS
cd /path/to/nixos
sudo nixos-rebuild switch --flake .#wsl
```

应用完成后，可以通过 `wsl --shutdown` 后重新启动发行版，使默认用户设置生效。上述命令只作操作记录，仓库维护时不会由 agent 自动执行。
