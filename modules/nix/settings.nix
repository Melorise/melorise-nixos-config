{ ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];

    extra-substituters = [
      "https://melorise-cp-nix.cachix.org"
      "https://meloasr.cachix.org"
    ];

    trusted-public-keys = [
      "melorise-cp-nix.cachix.org-1:GNg96VizkktTdGMrvl6+PLPHY3jPce4a72HqP2cj4S4="
      "meloasr.cachix.org-1:oMmpfj7D1pQTtJx6cHYupvPDJPFlkBB0JIpJYvkR5hc="
    ];

    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;
}
