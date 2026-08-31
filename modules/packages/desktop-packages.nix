{ pkgs-unstable, pkgs-thirdParty, ... }:

{
  services.linyaps = {
    enable = true;
    package = pkgs-unstable.linyaps;
    boxPackage = pkgs-unstable.linyaps-box;
    webStoreInstallerPackage = pkgs-unstable.linyaps-web-store-installer;
  };

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  environment.systemPackages = [
    pkgs-thirdParty.meloasr
  ];
}
