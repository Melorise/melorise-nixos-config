{ pkgs-unstable, pkgs-thirdParty, ... }:

{
  services.linyaps = {
    enable = true;
    package = pkgs-unstable.linyaps;
    boxPackage = pkgs-unstable.linyaps-box;
    webStoreInstallerPackage = pkgs-unstable.linyaps-web-store-installer;
  };

  systemd.tmpfiles.rules = [
    "z /var/lib/linglong 0755 deepin-linglong deepin-linglong -"
    "C /var/lib/linglong/config.yaml 0644 deepin-linglong deepin-linglong - ${pkgs-unstable.linyaps}/share/linglong/config.yaml"
  ];

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  environment.systemPackages = [
    pkgs-thirdParty.meloasr
  ];
}
