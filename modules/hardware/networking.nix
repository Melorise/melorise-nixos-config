{ ... }:

{
  networking = {
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    networkmanager = {
      enable = true;
    };

    firewall.enable = false;
  };
}
