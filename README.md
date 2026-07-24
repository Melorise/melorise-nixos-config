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
