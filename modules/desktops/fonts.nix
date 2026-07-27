{ pkgs, pkgs-thirdParty, ... }:

{
  fonts = {
    packages = [
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.noto-fonts-color-emoji
      pkgs-thirdParty.spark-winfonts
    ];

    # Keep generic font families pinned so installing additional fonts does not
    # change the system UI or terminal font selection.
    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans CJK SC" ];
      serif = [ "Noto Serif CJK SC" ];
      monospace = [ "Noto Sans Mono CJK SC" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
