{ pkgs, ... }:

{
  home.username = "tippy";
  home.homeDirectory = "/home/tippy";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    fd
    htop
  ];

  programs.git.enable = true;

  programs.git.settings = {
    user.name = "Melorise";
    user.email = "0d00@0721.hk";
  };

  programs.ssh = {
    enable = true;

    extraConfig = ''
      Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/github
    '';
  };

}
