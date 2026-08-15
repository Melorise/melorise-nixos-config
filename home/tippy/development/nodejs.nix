{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_24
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };

  home.file.".local/bin/dsh" = {
    executable = true;
    text = ''
      #!${pkgs.runtimeShell}
      exec ${pkgs.nodejs_24}/bin/node --expose-internals "$HOME/.npm-global/bin/dsh" "$@"
    '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];
}
