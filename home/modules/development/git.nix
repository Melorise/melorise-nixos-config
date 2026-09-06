{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Melorise";
      user.email = "0d00@0721.hk";
      init.defaultBranch = "main";
    };
  };
}
