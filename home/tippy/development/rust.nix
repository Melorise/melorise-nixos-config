{ lib, pkgs, ... }:

let
  # Tauri 2 在 Linux 上使用 GTK3、WebKitGTK 4.1，并由各 -sys crate 通过
  # pkg-config 查找对应的 C 库。列表同时用于生成编译期与运行期搜索路径。
  tauriLibraries = with pkgs; [
    at-spi2-core
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    libayatana-appindicator
    librsvg
    libsoup_3
    # Nixpkgs 的 xdotool 包同时提供 Tauri 所需的 libxdo。
    xdotool
    openssl
    pango
    webkitgtk_4_1
  ];
in
{
  # 用 Home Manager 配置项安装 cargo 并管理 ~/.cargo/config.toml
  programs.cargo = {
    enable = true;
    settings = { };
  };

  home.packages = with pkgs; [
    pkg-config
    rustc
    rustfmt
    clippy
    rust-analyzer
  ] ++ tauriLibraries;

  home.sessionVariables = {
    PKG_CONFIG_PATH = lib.makeSearchPathOutput "dev" "lib/pkgconfig" tauriLibraries;
    LD_LIBRARY_PATH = lib.makeLibraryPath tauriLibraries;
  };
}
