{ pkgs, pkgs-thirdParty, ... }:

let
  editorFonts = [
    (pkgs.noto-fonts-cjk-sans.override { static = true; })
    pkgs.corefonts
    pkgs.dejavu_fonts
    pkgs.liberation_ttf
  ];
  fontsConf = pkgs.makeFontsConf {
    fontDirectories = editorFonts;
    impureFontDirectories = [ ];
    includes = [ "${pkgs.fontconfig.out}/etc/fonts/conf.d" ];
  };
  unityhub = pkgs.unityhub.override {
    extraPkgs = _pkgs: editorFonts;
    buildFHSEnv = args: pkgs.buildFHSEnv (args // {
      profile = (args.profile or "") + "\n" + ''
        export FONTCONFIG_FILE="${fontsConf}"
      '';
    });
  };
in
{
  home.packages = [
    unityhub
    pkgs-thirdParty.tuanjiehub
  ];
}
