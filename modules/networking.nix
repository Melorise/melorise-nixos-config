{ ... }:

{
  networking = {
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # AdGuard Home provides the local resolver; NetworkManager must not replace it.
    nameservers = [
      "127.0.0.1"
      "::1"
    ];

    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services.adguardhome = {
    enable = true;
    host = "127.0.0.1";
    port = 3000;
    openFirewall = false;
    mutableSettings = true;

    settings = {
      dns = {
        bind_hosts = [
          "127.0.0.1"
          "::1"
        ];
        port = 53;
        upstream_dns = [
          "https://dns.alidns.com/dns-query"
          "https://doh.pub/dns-query"
        ];
        bootstrap_dns = [
          "223.5.5.5"
          "119.29.29.29"
        ];
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        filters_update_interval = 1;
      };

      filters = [
        {
          enabled = true;
          url = "https://raw.hellogithub.com/hosts";
          name = "GitHub520 Hosts";
          id = 1;
        }
      ];
    };
  };
}
