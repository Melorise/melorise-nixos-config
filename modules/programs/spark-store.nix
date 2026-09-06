{ inputs, pkgs-thirdParty, ... }:

{
  imports = [ inputs.amber-pm.nixosModules.default ];

  programs.amber-pm = {
    enable = true;
    package = pkgs-thirdParty.amber-pm;
    initializeState = true;
  };

  environment.systemPackages = [
    pkgs-thirdParty.spark-store
  ];
}
