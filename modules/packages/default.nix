{ pkgs, ... }:

{

  nix.settings = {
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];
    extra-substituters = [
      "https://melorise-cp-nix.cachix.org"
      "https://meloasr.cachix.org"
    ];
    trusted-public-keys = [
      "melorise-cp-nix.cachix.org-1:GNg96VizkktTdGMrvl6+PLPHY3jPce4a72HqP2cj4S4="
      "meloasr.cachix.org-1:oMmpfj7D1pQTtJx6cHYupvPDJPFlkBB0JIpJYvkR5hc="
    ];
  };

  nixpkgs.config.allowUnfree = true;
  
  #firefox
  #programs.firefox.enable = true;

  # 用于自动进入开发环境的direnv
  programs.direnv.enable = true;

  # 支持运行 AppImage，并通过 binfmt 允许直接执行 .AppImage 文件
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    fastfetch
    gcc
    gnumake
    binutils
    pkg-config
    cmake
    ninja
    autoconf
    automake
    libtool
    m4
    bison
    flex
    gettext
    gawk
    patch
    file
    which
    gdb
    unzip
    zip

    mission-center
  ];
}
