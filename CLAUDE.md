# 个人NixOS配置

这是我的个人nixos配置，使用nix flakes + home manager管理。当前NixOS版本为26.05。

## 你需要协助我管理，但不能越权
当我要求你进行修改时，你必须向我汇报你的改动计划，然后才能修改。
你只允许改动文件本身。绝对禁止自行执行nix flake lock, nix flake update, nixos-rebuild等任何指令。
每次更改，提交git commit,但不要推送到远程。
如果有内容变化或文件新增，更新AGENTS.md并拷贝一份到CLAUDE.md。

## 结构概览

```text
.
├── flake.nix                         Flake 入口；定义输入和两台设备输出
├── flake.lock                        Flake 输入版本锁定文件
├── AGENTS.md                         Codex 协作与仓库维护规范
├── CLAUDE.md                         Claude 协作规范
├── README.md                         项目简介与常用维护命令
├── hosts/
│   ├── desktop/
│   │   ├── default.nix               台式机设备配置与 GRUB 设置
│   │   └── hardware-configuration.nix 台式机硬件/磁盘生成配置
│   └── asus/
│       ├── default.nix               华硕设备配置与 GRUB/Windows 探测设置
│       └── hardware-configuration.nix 华硕硬件/磁盘生成配置
├── modules/
│   ├── audio.nix                     系统级 PipeWire 音频配置
│   ├── desktop-cinnamon.nix          系统级 Cinnamon 桌面配置
│   ├── gc.nix                        系统世代保留数量配置
│   ├── locale.nix                    系统级中文 locale 和 Fcitx5 配置
│   ├── networking.nix                系统级网络配置
│   ├── nvidia.nix                    ASUS 混合显卡与 NVIDIA PRIME 配置
│   ├── packages.nix                  系统级软件及其 NixOS 配置
│   └── users-tippy.nix               系统级 tippy 用户配置
└── home/tippy/
    ├── default.nix                   Home Manager 用户配置入口
    ├── ai-agent.nix                  AI agent 类用户软件
    ├── git.nix                       Git 用户配置
    ├── nodejs.nix                    Node.js 与 npm 用户配置
    ├── python.nix                    Python 3.14 用户环境
    ├── packages.nix                  稳定版通用用户软件
    ├── packages-unstable.nix         unstable 通用用户软件
    └── ssh.nix                       SSH 用户配置
```

## 配置分层

- `hosts/` 和 `modules/` 是 NixOS 系统级配置。
- `home/tippy/` 是 Home Manager 用户级配置。
- 绝大部分用户态软件应安装在 Home Manager。
- 系统级仅安装少量通用软件，或必须依赖系统服务、系统权限、网络/TUN、桌面服务等 NixOS 配置的软件。
- 新增用户态软件时，优先放入 `home/tippy/`；不要因为方便而直接添加到 `modules/packages.nix`。

## 软件与配置的放置规则

### 优先使用模块配置项

如果 NixOS 或 Home Manager 已提供对应的软件配置项，应优先使用配置项启用和配置软件，而不是只把软件包加入 `home.packages` 或 `environment.systemPackages`。

例如：

```nix
programs.firefox.enable = true;
```

配置项能同时表达软件安装和相关服务、默认设置或集成逻辑时，应优先使用这种方式。

### 配置按软件聚合并优先嵌套

同一软件的安装、开关和相关设置应集中在同一个文件、同一个属性块中，优先使用嵌套属性表达层级关系。

例如 Clash Verge 的全部系统级设置集中在一起：

```nix
programs.clash-verge = {
  enable = true;
  tunMode = true;
  serviceMode = true;
};
```

不要把同一软件的相关配置无必要地分散到多个文件或多个不相邻的属性块中。

### Home Manager 的分类优先级

用户态软件先判断是否属于已有的专用分类；只有不属于专用分类的软件，才进入通用软件包文件。

分类顺序如下：

1. 有明确用途或需要配套配置的软件，放入对应专用文件。
   - AI agent 相关软件放入 `ai-agent.nix`。
   - Node.js 相关软件和 npm 环境变量放入 `nodejs.nix`。
   - Python 解释器及相关环境配置放入 `python.nix`。
   - Git 配置放入 `git.nix`。
   - SSH 配置放入 `ssh.nix`。
2. 不属于任何专用分类的普通用户软件，再按更新频率选择通用文件：
   - `packages-unstable.nix`：更新频繁、无需刻意控制版本的软件，例如 Chrome。
   - `packages.nix`：时效性不强、可以数月不更新的软件，例如 `ripgrep`、`fd`、`htop`。

AI agent 只是专用分类的一个例子。后续出现新的明确类别时，应新建语义清晰的专用文件并在 `home/tippy/default.nix` 导入，而不是把所有软件都堆入两个通用 packages 文件。

## 文件说明

### 根目录

- `flake.nix`：Flake 入口，定义 stable/unstable nixpkgs 与 Home Manager 输入。通过 `mkHost` 生成 `desktop` 和 `asus` 两台设备的 NixOS 配置；设备差异由各自 `hosts/` 目录提供。
- `flake.lock`：锁定 Flake 输入的具体版本。除非用户明确要求，不要自行更新。
- `AGENTS.md`：本仓库的 Codex 协作规范和配置约定。
- `CLAUDE.md`：Claude 协作规范，内容与 `AGENTS.md` 保持一致。
- `README.md`：项目简介与常用 Nix 命令记录。记录不代表可以自行执行，仍须遵守本文件的基础原则。

### `hosts/`

- `hosts/desktop/default.nix`：台式机的设备级入口，设置主机名、GRUB 引导方式，并导入通用系统模块。
- `hosts/desktop/hardware-configuration.nix`：台式机硬件自动生成配置，包含磁盘 UUID、文件系统、交换分区和内核模块。通常不手动修改。
- `hosts/asus/default.nix`：华硕设备的设备级入口，设置主机名和 UEFI GRUB，启用 Windows 启动项探测，并导入通用系统模块。
- `hosts/asus/hardware-configuration.nix`：华硕硬件自动生成配置，包含磁盘 UUID、文件系统、交换分区和内核模块。通常不手动修改。

### `modules/`

- `modules/audio.nix`：启用 PipeWire、ALSA、PulseAudio 兼容层和 realtime 权限。
- `modules/desktop-cinnamon.nix`：启用 X11、LightDM、Cinnamon 及中文键盘布局。
- `modules/gc.nix`：限制 GRUB 最多保留 10 个可启动的系统世代。
- `modules/locale.nix`：设置上海时区、中文 locale 与 Fcitx5 中文输入法。
- `modules/networking.nix`：启用无线网络支持和 NetworkManager。
- `modules/nvidia.nix`：ASUS 设备的 AMD 核显与 NVIDIA 独显配置，启用 NVIDIA 驱动、电源管理和 PRIME offload。
- `modules/packages.nix`：系统级软件与软件模块配置；当前包含 Nix 镜像、`allowUnfree`、Clash Verge、少量基础工具及既有的 Chrome 配置。新增普通用户态软件不应默认放在这里。
- `modules/users-tippy.nix`：定义 `tippy` 系统用户和 `networkmanager`、`wheel` 用户组。

### `home/tippy/`

- `home/tippy/default.nix`：Home Manager 入口，设置用户、家目录和状态版本，并导入所有用户级分类配置。
- `home/tippy/ai-agent.nix`：AI agent 类用户软件，统一使用 `pkgs-unstable`。Claude Code、Codex、OpenCode、cc-switch 及后续同类软件均放在这里。
- `home/tippy/git.nix`：启用并配置用户级 Git，包括身份信息和默认分支。
- `home/tippy/nodejs.nix`：Node.js 专用配置，安装 Node.js 并设置 npm 全局包目录。Node.js 相关内容应集中在这里。
- `home/tippy/python.nix`：Python 专用配置，安装稳定源的 Python 3.14。Python 解释器及相关环境配置应集中在这里。
- `home/tippy/packages.nix`：稳定版通用用户软件，存放不属于专用分类且更新频率较低的软件。
- `home/tippy/packages-unstable.nix`：unstable 通用用户软件，存放不属于专用分类但更新频繁的软件；已由 `default.nix` 导入。
- `home/tippy/ssh.nix`：启用并配置用户级 SSH，包括 GitHub 主机连接规则。
