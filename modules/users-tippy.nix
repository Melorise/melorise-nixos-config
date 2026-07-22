{ ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."tippy" = {
    isNormalUser = true;
    description = "tippy";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
