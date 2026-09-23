{ pkgs, ... }:

{
  services.linyaps = {
    enable = true;
    package = pkgs.linyaps;
    boxPackage = pkgs.linyaps-box;
    webStoreInstallerPackage = pkgs.linyaps-web-store-installer;
  };

  systemd.tmpfiles.rules = [
    "z /var/lib/linglong 0755 deepin-linglong deepin-linglong -"
    "C /var/lib/linglong/config.yaml 0644 deepin-linglong deepin-linglong - ${pkgs.linyaps}/share/linglong/config.yaml"
  ];

  systemd.services."org.deepin.linglong.PackageManager".wantedBy = [
    "multi-user.target"
  ];
}
