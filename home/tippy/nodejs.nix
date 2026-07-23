{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_24
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
}
