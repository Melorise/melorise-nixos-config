{ pkgs, ... }:

{
  # 用 Home Manager 配置项安装 cargo 并管理 ~/.cargo/config.toml
  programs.cargo = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    pkg-config
    dbus.dev
    rustc
    rustfmt
    clippy
    rust-analyzer
  ];

  # libdbus-sys 通过 pkg-config 查找 dbus-1.pc；该文件位于 dbus 的 dev 输出中。
  home.sessionVariables.PKG_CONFIG_PATH = "${pkgs.dbus.dev}/lib/pkgconfig";
}
