{ pkgs-thirdParty, ... }:

{
  services.linyaps.enable = true;

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  environment.systemPackages = [
    pkgs-thirdParty.meloasr
  ];
}
