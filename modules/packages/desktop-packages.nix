{ pkgs-thirdParty, ... }:

{
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  environment.systemPackages = [
    pkgs-thirdParty.meloasr
  ];
}
