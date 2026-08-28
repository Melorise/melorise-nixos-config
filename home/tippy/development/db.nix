{ pkgs, ... }:

let
  dbx = pkgs.dbx.override {
    python3 = pkgs.python313;
  };
in

{
  home.packages = [
    dbx
  ];
}
