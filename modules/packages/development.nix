{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    gdb
  ];
}
