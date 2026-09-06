{ inputs, ... }:

{
  imports = [ inputs.npanel.nixosModules.default ];

  services.nPanel = {
    enable = true;
    port = 4096;
    securityEntrance = "npanel";
  };
}
