{ inputs, pkgs-unstable, pkgs-thirdParty, ... }:

{
  imports = [ inputs.clash-party.nixosModules.clash-party ];

  programs = {
    clash-party = {
      enable = true;
      package = pkgs-thirdParty.clash-party;
    };

    clash-verge = {
      enable = true;
      tunMode = true;
      serviceMode = true;
      package = pkgs-unstable.clash-verge-rev;
    };
  };
}
