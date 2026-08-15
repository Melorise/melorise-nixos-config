{ pkgs-unstable, pkgs-thirdParty, ... }:

{
  home.packages =
    (with pkgs-unstable; [
      claude-code
      codex
      opencode

      cc-switch
    # ])
    # ++ (with pkgs-thirdParty; [
    #   codex-desktop
    ]);

#   # Codex Desktop 内置的旧版 GLib 无法加载当前系统的 fcitx5-gtk 模块。
#   # 仅覆盖用户级启动项并改用 XIM，既不影响其他应用，也能保持原包命中 Cachix。
#   xdg.desktopEntries.codex-desktop = {
#     name = "ChatGPT";
#     comment = "Run ChatGPT Desktop on Linux";
#     icon = "codex-desktop";
#     exec = "env GTK_IM_MODULE=xim CHROME_DESKTOP=codex-desktop.desktop ${pkgs-thirdParty.codex-desktop}/bin/codex-desktop %u";
#     terminal = false;
#     categories = [ "Development" ];
#     mimeType = [
#       "x-scheme-handler/codex"
#       "x-scheme-handler/codex-browser-sidebar"
#     ];
#     settings = {
#       Keywords = "codex;openai;ai;coding;";
#       StartupNotify = "true";
#       StartupWMClass = "codex-desktop";
#       X-GNOME-WMClass = "codex-desktop";
#     };
#   };
}
