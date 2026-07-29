{ inputs, ... }:

{
  imports = [ inputs.npanel.nixosModules.default ];

  services.nPanel.enable = true;
}
