{ pkgs, ... }:

{
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
