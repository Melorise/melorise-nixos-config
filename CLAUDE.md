# 个人 NixOS 配置

这是我的个人 NixOS 配置，使用 Nix Flakes 和 Home Manager 管理。当前 NixOS 版本为 26.05。

## 你需要协助我管理，但不能越权

当我要求你修改配置时，必须先汇报完整改动计划。未经我在对话中明确确认该计划，严禁修改文件，不能汇报计划后自动开始动工。

只允许修改文件本身。严禁自行执行 `nix flake lock`、`nix flake update`、`nixos-rebuild` 等 Nix 构建、更新或应用命令。

`flake.lock` 是由 Nix 自动生成的锁定文件，绝对禁止手工编辑、替换、重排或以任何方式修改。无论任务内容是什么，一律不得读取、检查、验证、暂存或修改 `flake.lock`。配置源码与锁文件必须作为独立 Git 改动处理，锁文件只由用户自行执行 Nix 命令生成。若当前任务中的 agent 已手工改动该文件，必须立即停止相关操作并询问用户如何处理；用户自行执行 Nix 命令留下的未提交锁文件改动必须原样保留。

每次完成更改后必须创建 Git commit，但不要推送到远程。暂存时显式指定本次修改的文件，不得暂存 `flake.lock`。

如果有内容变化或新增文件，必须更新 `AGENTS.md`，并将相同内容同步到 `CLAUDE.md`。

`AGENTS.md` 的结构概览只保存简短文件职责；具体配置详情写在文件说明中。

## 目录与模块边界

### 系统配置

- `hosts/` 只保存每台设备的 NixOS 入口和硬件配置。每个 `hosts/<设备>/default.nix` 必须显式导入该设备需要的系统模块，使设备最终启用的系统功能可以直接阅读。
- `modules/` 只保存可复用的 NixOS 系统模块，禁止放入 Home Manager 配置或普通用户的软件选择。
- 系统模块按实际职责分类：桌面、硬件、网络、Nix、系统包、程序集成、服务、存储和系统用户。
- 不建立隐藏设备选择的通用 system profile。只有确实始终作为同一功能使用的配置才能放在同一个系统模块中。
- `hardware-configuration.nix` 保存设备扫描得到的硬件、文件系统和 UUID。通常不修改；若挂载策略本身是明确需求，例如 Btrfs 压缩参数，可以在用户确认后修改。

### Home Manager 配置

- `home/modules/` 保存跨用户、跨设备复用的 Home Manager 模块。共享模块不得硬编码用户名、家目录、主机名或设备判断。
- `home/users/` 只保存用户身份，包括用户名、家目录和 Home Manager state version，不负责选择软件。
- `home/profiles/<设备>/<用户>.nix` 是用户态功能的唯一组合入口，必须显式导入该设备上该用户需要的 Home Manager 模块。
- Home profile 禁止声明 NixOS 系统选项；`hosts/` 和 `modules/` 也禁止编排 Home Manager 用户模块。
- 同一个用户在不同设备上的 profile 可以拥有不同软件集合；不同用户也必须复用 `home/modules/` 中相同的功能模块，禁止复制整棵用户配置。

### Flake 职责

- `flake.nix` 负责声明输入、构造包集、创建 NixOS configuration，并将系统主机与对应的 Home profile 配对。
- `flake.nix` 不替主机选择具体系统功能，也不替 Home profile 选择用户软件。
- 第三方 NixOS module 应由使用它的本地系统功能模块导入；不要在 Flake 中向所有设备全局注入，也不要维护与业务模块分离的 `extraNixosModules` 列表。

### 模块拆分与软件放置

- 系统态与 Home Manager 的管理边界由软件的实际用途决定，不能为了共享或目录对称而改变管理层级。
- 普通用户态软件原则上由 Home Manager 管理。需要系统服务、系统权限、网络/TUN、Polkit、显示管理器、文件系统或其他 NixOS 集成的软件保留在系统态。
- 优先使用 NixOS 或 Home Manager 已提供的配置项；只有没有合适配置项时才加入 `environment.systemPackages` 或 `home.packages`。
- 软件版本来源是模块内部实现细节。禁止以 stable、unstable 或第三方来源作为目录和文件分类，禁止重新建立 `packages-unstable.nix` 一类文件。
- 多个包只有在所有设备上都作为同一选择单元时才能放入同一个模块。会被设备独立取舍的软件必须拆为独立模块。
- 禁止重新建立类似旧 `modules/packages/default.nix` 的综合模块。Nix 设置、基础工具链、开发工具链、AppImage、direnv 和桌面应用必须分别维护。
- 新增模块前先检查现有功能模块。只有出现新的独立选择单元时才新建文件，避免无意义的一包一文件。
- 同一软件的安装、开关、服务和相关设置应集中在同一文件、同一属性块中，并优先使用嵌套属性。

## 结构概览

```text
.
├── flake.nix                         Flake 输入、包集、主机构造和 Home profile 配对
├── flake.lock                        Flake 输入版本锁定文件
├── AGENTS.md                         Codex 协作、目录和配置维护规范
├── CLAUDE.md                         与 AGENTS.md 同步的 Claude 协作规范
├── README.md                         项目简介与用户手动执行的维护命令
├── hosts/
│   ├── desktop/                      台式机系统入口与硬件配置
│   ├── asus/                         ASUS 系统入口与硬件配置
│   └── wsl/                          NixOS-WSL 系统入口
├── modules/
│   ├── desktop/                      桌面环境、字体和本地化系统模块
│   ├── hardware/                     音频与设备专用硬件模块
│   ├── networking/                   物理机网络策略模块
│   ├── nix/                          Nix daemon 设置与垃圾回收模块
│   ├── packages/                     系统基础包和开发工具链模块
│   ├── programs/                     需要 NixOS 集成的程序模块
│   ├── services/                     Docker、nPanel 等系统服务
│   ├── storage/                      文件系统与 zram 模块
│   └── users/                        NixOS 系统用户定义
└── home/
    ├── modules/                      可复用的 Home Manager 功能模块
    ├── users/                        Home Manager 用户身份
    └── profiles/                     各设备与用户的用户态功能组合
```

## 包集与第三方来源

- `pkgs` 是 NixOS 26.05 稳定包集，`pkgs-unstable` 是 unstable 包集。
- 所有不在 nixpkgs 的第三方软件包通过 `thirdPartyOverlays` 统一加入 `pkgs-thirdParty`，业务模块只接收单一的 `pkgs-thirdParty` 参数。
- Amber PM、CC Switch、Clash Party、ChatGPT、TamaASR、NixOS-WSL、Spark Store 与 Spark Winfonts 分别作为独立 Flake input。
- 对存在上游缓存的软件，不增加 `nixpkgs.follows`，不使用 `overrideAttrs` 改写上游包，以保留缓存命中。没有缓存的输入应跟随现有 nixpkgs 输入以减少闭包占用。
- Spark Store 不是 Flake，由 `thirdPartyOverlays` 调用其 `nix/package.nix`，并注入同一 `pkgs-thirdParty` 中的 Amber PM。
- CERNET Nixpkgs 镜像、Clash Party 和 TamaASR Cachix 地址及公钥统一由 `modules/nix/settings.nix` 配置。TamaASR 继续使用旧名称 `meloasr.cachix.org`。
- Clash Party、Amber PM、nPanel 和 NixOS-WSL 的上游 NixOS module 分别由实际使用它们的系统模块或主机入口导入。

## 主机与 Home profile 对应关系

| NixOS configuration | 系统入口 | 用户 | Home profile |
|---|---|---|---|
| `desktop` | `hosts/desktop/default.nix` | `tippy` | `home/profiles/desktop/tippy.nix` |
| `asus` | `hosts/asus/default.nix` | `tippy` | `home/profiles/asus/tippy.nix` |
| `wsl` | `hosts/wsl/default.nix` | `nixos` | `home/profiles/wsl/nixos.nix` |

## 文件说明

### 根目录与主机

- `flake.nix`：定义 stable/unstable nixpkgs、Home Manager 和第三方输入，构造 `pkgs-unstable` 与 `pkgs-thirdParty`，并通过 `mkHost` 创建三台设备。Home Manager 的 NixOS 集成只在这里完成；具体用户功能由传入的 Home profile 决定。
- `hosts/desktop/default.nix`：台式机系统配置，使用 BIOS GRUB、Cinnamon、Docker、物理机网络、系统开发工具、桌面程序与 `tippy` 用户。
- `hosts/desktop/hardware-configuration.nix`：台式机自动生成的硬件、磁盘 UUID、文件系统、交换分区和内核模块。
- `hosts/asus/default.nix`：ASUS 系统配置，使用 UEFI GRUB、Cinnamon、NVIDIA、Docker、nPanel、Spark Store 和物理机桌面程序。
- `hosts/asus/hardware-configuration.nix`：ASUS 自动生成的硬件和磁盘配置。
- `hosts/wsl/default.nix`：NixOS-WSL 系统配置，默认用户为 `nixos`，只启用 CLI 系统环境、Docker、GC 和必要的 Nix 设置。

### 系统模块

- `modules/desktop/cinnamon.nix`：Cinnamon、LightDM 和 X11。
- `modules/desktop/fonts.nix`：Noto CJK、Emoji、Meslo Nerd Font、Spark Winfonts 和固定的 fontconfig 默认字体。
- `modules/desktop/locale.nix`：上海时区、中文 locale、Fcitx5 中文输入法和中文 XKB 布局。
- `modules/hardware/audio.nix`：PipeWire、ALSA、PulseAudio 兼容层和 realtime 权限。
- `modules/hardware/nvidia.nix`：ASUS NVIDIA 驱动、电源管理、混合模式和 `nvidia-offload`。
- `modules/networking/physical.nix`：物理机无线网络、NetworkManager 和现有关闭防火墙策略。
- `modules/nix/settings.nix`：Flakes、镜像、第三方缓存、非自由软件许可和所有设备的 store 自动优化。
- `modules/nix/gc.nix`：每天垃圾回收并删除三天前的旧世代。
- `modules/packages/base.nix`：系统管理和诊断所需的基础命令行工具。
- `modules/packages/development.nix`：系统级 C/C++ 与原生项目构建工具链。
- `modules/packages/mission-center.nix`：物理桌面使用的 Mission Center。
- `modules/programs/appimage.nix`：AppImage 支持与 binfmt 直接执行。
- `modules/programs/direnv.nix`：系统级启用 direnv。
- `modules/programs/clash.nix`：Clash Party 与 Clash Verge，包含 TUN、service mode、上游模块和指定包。
- `modules/programs/linyaps.nix`：Linyaps 主程序、沙盒、商店安装器、状态目录和服务初始化。
- `modules/programs/spark-store.nix`：Amber PM 系统集成、首次状态初始化和 Spark Store。
- `modules/programs/steam.nix`：Steam 与 Protontricks。
- `modules/programs/tama-asr.nix`：安装自行管理自动启动的 TamaASR。
- `modules/services/docker.nix`：开机启动的 rootful Docker 和 Docker Compose。
- `modules/services/npanel.nix`：nPanel 上游模块和服务设置，使用端口 4096 与安全入口 `/npanel`。
- `modules/storage/ntfs.nix`：启用 ntfs-3g，并让 UDisks 使用 ntfs-3g 而非内核 ntfs3 驱动。
- `modules/storage/zram.nix`：使用 NixOS 默认参数启用 zram swap。
- `modules/users/tippy.nix`：创建 `tippy` 系统用户，启用 Zsh，并赋予 Docker、NetworkManager 与 wheel 组权限。
- `modules/users/nixos.nix`：创建 WSL `nixos` 系统用户，启用 Zsh，并赋予 Docker 与 wheel 组权限。

### Home Manager 模块

- `home/modules/config/zsh.nix`：共享的 Zsh、补全、语法高亮、命令建议与 Powerlevel10k 配置。
- `home/modules/development/git.nix`：共享 Git 身份和默认分支。
- `home/modules/development/ssh.nix`：共享 GitHub 与 Gitee SSH 主机规则。
- `home/modules/development/nodejs.nix`：Node.js 24、npm 全局目录、用户 PATH 和 `dsh` 包装脚本。
- `home/modules/development/pnpm.nix`：独立安装 pnpm，供需要它的设备 profile 选择。
- `home/modules/development/python.nix`：Python 3.14。
- `home/modules/development/rust.nix`：cargo、rustc、rustfmt、Clippy 与 rust-analyzer；额外 Rust 技术栈继续使用 `~/DevTemplates/` 下的 direnv 项目模板。
- `home/modules/development/vscode.nix`：unstable 的 FHS VS Code。
- `home/modules/development/unityhub.nix`：Unity Hub。
- `home/modules/development/ai/cc-switch.nix`：使用 `pkgs-thirdParty` 安装 CC Switch。
- `home/modules/development/ai/*.nix`：Claude Code、Codex、OpenCode 和 ChatGPT 的独立用户态选择模块；ChatGPT 使用 `pkgs-thirdParty`，其余使用 unstable。
- `home/modules/packages/cli.nix`：ripgrep、fd 和 htop。
- `home/modules/packages/chrome.nix`：unstable Google Chrome。
- `home/modules/packages/qq.nix`：unstable QQ。
- `home/users/*.nix`：分别定义 `tippy` 和 `nixos` 的用户名、家目录与 Home Manager state version。
- `home/profiles/desktop/tippy.nix`：台式机 `tippy` 的完整开发、AI 和桌面应用组合。
- `home/profiles/asus/tippy.nix`：ASUS `tippy` 的完整开发、AI 和桌面应用组合。
- `home/profiles/wsl/nixos.nix`：WSL `nixos` 的 CLI 开发和 AI 工具组合，不包含图形应用与 pnpm。
