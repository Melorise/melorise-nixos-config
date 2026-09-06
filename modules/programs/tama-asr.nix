{ pkgs-thirdParty, ... }:

{
  environment.systemPackages = [
    pkgs-thirdParty.tama-asr
  ];
}
