{ pkgs, ... }:

{

  nix.settings = {
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];
    extra-substituters = [
      "https://melorise-cp-nix.cachix.org"
    ];
    trusted-public-keys = [
      "melorise-cp-nix.cachix.org-1:GNg96VizkktTdGMrvl6+PLPHY3jPce4a72HqP2cj4S4="
    ];
  };

  nixpkgs.config.allowUnfree = true;
  
  #firefox
  #programs.firefox.enable = true;

  # 用于自动进入开发环境的direnv
  programs.direnv.enable = true;

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
  ];
 
  
}
