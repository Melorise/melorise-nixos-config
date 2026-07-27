# 个人NixOS配置

这是我的个人nixos配置，使用nix flakes + home manager管理。当前NixOS版本为26.05。

## 你需要协助我管理，但不能越权
当我要求你进行修改时，你必须向我汇报你的改动计划。   
未经我明确的对话进行授权确认你的计划，严禁进行修改。
绝对禁止汇报个计划就自动开始动工而未收到我的确认指令。    

你只允许改动文件本身。绝对禁止自行执行nix flake lock, nix flake update, nixos-rebuild等任何指令。  

每次更改，提交git commit,但不要推送到远程。  

如果有内容变化或文件新增，更新AGENTS.md并拷贝一份到CLAUDE.md。   

AGENTS.md的结构概览只存放简单的文件描述。具体详情请写在文件说明里。

## 结构概览

```text
.
├── flake.nix                         Flake 入口；定义包集、MNPR、第三方 overlay 和两台设备输出
├── flake.lock                        Flake 输入版本锁定文件
├── AGENTS.md                         Codex 协作与仓库维护规范
├── CLAUDE.md                         Claude 协作规范
├── README.md                         项目简介与常用维护命令
├── hosts/
│   ├── desktop/
│   │   ├── default.nix               台式机设备配置、Nix 信任用户与 GRUB 设置
│   │   └── hardware-configuration.nix 台式机硬件/磁盘生成配置
│   └── asus/
│       ├── default.nix               华硕设备配置、Nix 信任用户与 GRUB/Windows 探测设置
│       └── hardware-configuration.nix 华硕硬件/磁盘生成配置
├── modules/
│   ├── hardware/                     硬件与底层系统资源配置
│   │   ├── audio.nix                 PipeWire 音频配置
│   │   ├── filesystems.nix           文件系统与 UDisks 配置
│   │   ├── gc.nix                    Nix 自动垃圾回收配置
│   │   ├── networking.nix            网络与本地 DNS 配置
│   │   ├── nvidia.nix                ASUS NVIDIA 显卡配置
│   │   └── zram.nix                  zram 压缩交换空间配置
│   ├── desktops/                     桌面环境与本地化配置
│   │   ├── cinnamon.nix              Cinnamon 桌面配置
│   │   ├── fonts.nix                 系统字体安装与默认字体配置
│   │   └── locale.nix                中文 locale 与输入法配置
│   ├── packages/                     系统级软件及其集成配置
│   │   ├── default.nix               通用系统软件配置
│   │   └── spark-store.nix           Amber PM 与 Spark Store 集成
│   ├── users/
│   │   └── tippy.nix                 tippy 系统用户配置
│   └── development/                  系统级开发环境配置
│       └── docker.nix                Docker 与 Docker Compose 环境
└── home/tippy/
    ├── default.nix                   Home Manager 用户配置入口
    ├── development/                  开发相关软件与配置
    │   ├── ai-agent.nix              AI agent 类用户软件
    │   ├── git.nix                   Git 用户配置
    │   ├── nodejs.nix                Node.js 与 npm 用户配置
    │   ├── python.nix                Python 3.14 用户环境
    │   └── ssh.nix                   SSH 用户配置
    └── packages/                     日常及其他普通用户软件
        ├── packages.nix              稳定版通用用户软件
        └── packages-unstable.nix     unstable 通用用户软件
```

## 配置分层

- `hosts/` 和 `modules/` 是 NixOS 系统级配置。
- `home/tippy/` 是 Home Manager 用户级配置。
- 绝大部分用户态软件应安装在 Home Manager。
- 系统级仅安装少量通用软件，或必须依赖系统服务、系统权限、网络/TUN、桌面服务等 NixOS 配置的软件。
- 新增用户态软件时，优先放入 `home/tippy/`；不要因为方便而直接添加到 `modules/packages/default.nix`。

## 包集与第三方来源

- `pkgs` 是 NixOS 稳定版包集，`pkgs-unstable` 是 unstable 包集。
- 所有不在 nixpkgs 的第三方软件包都通过 `thirdPartyOverlays` 统一加入 `pkgs-thirdParty`，不要为每个第三方 Flake input 增加模块参数。后续接入其他第三方来源时，应向该 overlay 列表追加来源提供的 overlay 或必要的本地适配 overlay。
- MNPR 是当前第三方软件的统一 Flake input。本仓库通过通用 overlay 将 `inputs.mnpr.packages.${system}` 的全部软件包加入 `pkgs-thirdParty`，不在本地逐个映射包名；各模块只接收单一的 `pkgs-thirdParty` 参数。
- MNPR 保留各上游自身的锁定输入图，不设置 `nixpkgs.follows`，也不通过 `overrideAttrs` 改写转发的软件包，以保持上游缓存命中。
- MNPR 转发的默认 NixOS module 通过 `thirdPartyNixosModules` 按条目名称统一聚合；只加入本配置实际使用的模块，避免 MNPR 后续新增模块时被自动启用。选择性缓存模块通过 `inputs.mnpr.nixosModules.caches` 单独引入，并在系统软件模块中按条目名称启用所需缓存。
- Amber PM 使用 MNPR 的 `amber-pm` 条目，Clash Party 使用 `clash-party` 条目；两者的上游默认 NixOS module 均由 MNPR 转发并通过 `thirdPartyNixosModules` 统一引入。Spark Store 使用 MNPR 的 `spark-store` 条目；上游仓库不是 Flake，由 MNPR 适配层调用其 `nix/package.nix`，并注入同属 MNPR 的 Amber PM 包。
- Spark Winfonts 使用 MNPR 的 `spark-winfonts` 条目，通过 `pkgs-thirdParty` 直接安装字体包，不引入上游 NixOS module；默认字体族继续由本地字体模块显式固定。
- Codex Desktop 使用 MNPR 的 `codex-desktop` 条目，该条目追踪 `Melorise/codex-desktop-linux-builder` 的 `nix` 分支。该分支由构建机在成功上传对应闭包后推进；本仓库通过 MNPR 及 `flake.lock` 锁定实际版本。
- Codex Desktop 与 Clash Party 的 Cachix URL 和公钥由 MNPR 条目维护，`modules/packages/default.nix` 只按条目名称选择启用。Codex Desktop 在 Home Manager 的 `development/ai-agent.nix` 中安装，Clash Party 通过 MNPR 转发的上游 NixOS module 在 `modules/packages/default.nix` 中启用。

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

用户态软件先判断是否与开发相关。开发相关的软件与配置放入 `home/tippy/development/`；日常软件和其他普通软件放入 `home/tippy/packages/`。

分类顺序如下：

1. 开发相关的软件与配置放入 `development/` 下的对应专用文件。
   - AI agent 相关软件放入 `development/ai-agent.nix`。
   - Node.js 相关软件和 npm 环境变量放入 `development/nodejs.nix`。
   - Python 解释器及相关环境配置放入 `development/python.nix`。
   - Git 配置放入 `development/git.nix`。
   - SSH 配置放入 `development/ssh.nix`。
   - 后续出现新的开发类别时，应在 `development/` 下新建语义清晰的专用文件，并在 `home/tippy/default.nix` 中导入。
2. 日常软件和其他普通软件放入 `packages/`，继续按更新频率选择文件：
   - `packages/packages-unstable.nix`：更新频繁、无需刻意控制版本的软件，例如 Chrome。
   - `packages/packages.nix`：时效性不强、可以数月不更新的软件，例如 `ripgrep`、`fd`、`htop`。

## 文件说明

### 根目录

- `flake.nix`：Flake 入口，定义 stable/unstable nixpkgs、Home Manager 与 MNPR 输入。MNPR 的全部软件包通过可扩展的 `thirdPartyOverlays` 加入 `pkgs-thirdParty`；MNPR 转发且本配置实际使用的默认 NixOS module 通过 `thirdPartyNixosModules` 统一引入，缓存模块单独引入。通过 `mkHost` 生成 `desktop` 和 `asus` 两台设备的 NixOS 配置；设备差异由各自 `hosts/` 目录提供。
- `flake.lock`：锁定 Flake 输入的具体版本。除非用户明确要求，不要自行更新。
- `AGENTS.md`：本仓库的 Codex 协作规范和配置约定。
- `CLAUDE.md`：Claude 协作规范，内容与 `AGENTS.md` 保持一致。
- `README.md`：项目简介与常用 Nix 命令记录。记录不代表可以自行执行，仍须遵守本文件的基础原则。

### `hosts/`

- `hosts/desktop/default.nix`：台式机的设备级入口，设置主机名、GRUB 引导方式、Nix 实验性功能，并将 `tippy` 配置为 Nix 信任用户；同时导入通用系统模块。
- `hosts/desktop/hardware-configuration.nix`：台式机硬件自动生成配置，包含磁盘 UUID、文件系统、交换分区和内核模块。通常不手动修改。
- `hosts/asus/default.nix`：华硕设备的设备级入口，设置主机名、UEFI GRUB 和 Nix 实验性功能，启用 Windows 启动项探测，并将 `tippy` 配置为 Nix 信任用户；同时导入通用系统模块。
- `hosts/asus/hardware-configuration.nix`：华硕硬件自动生成配置，包含磁盘 UUID、文件系统、交换分区和内核模块。通常不手动修改。

### `modules/`

- `modules/hardware/`：硬件与底层系统资源配置目录。
- `modules/hardware/audio.nix`：启用 PipeWire、ALSA、PulseAudio 兼容层和 realtime 权限。
- `modules/hardware/filesystems.nix`：启用 ntfs-3g 文件系统工具，并配置 UDisks 对 NTFS 分区使用 ntfs-3g 而不是内核 ntfs3 驱动。
- `modules/hardware/gc.nix`：每周自动执行 Nix 垃圾回收并删除 14 天前的旧世代，不限制 GRUB 启动项数量。
- `modules/hardware/networking.nix`：启用无线网络支持和 NetworkManager，并让仅监听本机的 AdGuard Home 接管系统 DNS；普通查询通过阿里与 DNSPod 的 DoH 上游解析，GitHub 域名使用每小时自动更新的 GitHub520 hosts 订阅。
- `modules/hardware/nvidia.nix`：ASUS 设备的 NVIDIA 驱动、电源管理和 X11 自动选卡配置；不固定 GPU BusID 或主显示卡，以兼容混合模式与独显直连，并提供 `nvidia-offload` 命令。
- `modules/hardware/zram.nix`：为两台设备启用使用 NixOS 默认参数的 zram 压缩交换空间，并保留磁盘 swap 作为后备。
- `modules/desktops/`：桌面环境、字体与本地化配置目录。
- `modules/desktops/cinnamon.nix`：启用 X11、LightDM、Cinnamon 及中文键盘布局。
- `modules/desktops/fonts.nix`：安装 Noto CJK 简体中文黑体、宋体、彩色 Emoji 字体及 MNPR 的 Spark Winfonts，并为无衬线、衬线、等宽及 Emoji 字体设置明确的 fontconfig 默认值，避免新增字体改变系统界面或终端的通用字体匹配。
- `modules/desktops/locale.nix`：设置上海时区、中文 locale 与 Fcitx5 中文输入法。
- `modules/packages/`：系统级软件及其集成配置目录。
- `modules/packages/default.nix`：系统级软件与软件模块配置；当前包含 Nix 镜像、通过 MNPR 条目选择启用的 Codex Desktop 与 Clash Party 缓存、`allowUnfree`、Clash Verge、需要 capability 包装器的 Clash Party，以及少量基础工具。新增普通用户态软件不应默认放在这里。
- `modules/packages/spark-store.nix`：仅由 ASUS 主机导入，启用 Amber PM 的系统级配置和首次状态初始化，并安装需要 Polkit 与桌面集成的 Spark Store。
- `modules/users/`：系统用户配置目录。
- `modules/users/tippy.nix`：定义 `tippy` 系统用户和 `docker`、`networkmanager`、`wheel` 用户组；`docker` 组允许无需 sudo 访问 rootful Docker daemon，具有近似 root 的权限。
- `modules/development/`：系统级开发环境配置目录。
- `modules/development/docker.nix`：为两台设备启用开机启动的 rootful Docker 服务，并安装 Docker Compose。

### `home/tippy/`

- `home/tippy/default.nix`：Home Manager 入口，设置用户、家目录和状态版本，并导入所有用户级分类配置。
- `home/tippy/development/`：开发相关软件与配置目录。后续新增的开发类别应在此目录中建立语义清晰的专用文件。
- `home/tippy/development/ai-agent.nix`：AI agent 类用户软件。Claude Code、Codex、OpenCode、cc-switch 使用 `pkgs-unstable`，Codex Desktop 使用 `pkgs-thirdParty`；同时通过用户级 desktop entry 仅为 Codex Desktop 设置 XIM，以绕过其内置旧版 GLib 与系统 `fcitx5-gtk` 的兼容问题并保持 Cachix 原包命中。后续同类软件均放在这里。
- `home/tippy/development/git.nix`：启用并配置用户级 Git，包括身份信息和默认分支。
- `home/tippy/development/nodejs.nix`：Node.js 专用配置，安装 Node.js 并设置 npm 全局包目录。Node.js 相关内容应集中在这里。
- `home/tippy/development/python.nix`：Python 专用配置，安装稳定源的 Python 3.14。Python 解释器及相关环境配置应集中在这里。
- `home/tippy/development/ssh.nix`：启用并配置用户级 SSH，包括 GitHub 主机连接规则。
- `home/tippy/packages/`：日常软件和其他普通软件目录，继续按更新频率区分稳定版与 unstable 包。
- `home/tippy/packages/packages.nix`：稳定版通用用户软件，存放时效性不强、可以数月不更新的软件。
- `home/tippy/packages/packages-unstable.nix`：unstable 通用用户软件，存放更新频繁、无需刻意控制版本的软件；已由 `default.nix` 导入。
