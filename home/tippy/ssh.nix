{ ... }:

{
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
