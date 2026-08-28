{ pkgs, ... }:

{
  # 用 Home Manager 配置项安装 cargo 并管理 ~/.cargo/config.toml
  programs.cargo = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    rustc
    rustfmt
    clippy
    rust-analyzer
  ];
}
