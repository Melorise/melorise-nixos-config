{ pkgs, ... }:

{
  # 用于自动进入开发环境的direnv
  programs.direnv.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    htop

    qq
  ];
}
