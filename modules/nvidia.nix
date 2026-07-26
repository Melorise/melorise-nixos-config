{ config, lib, pkgs, ... }:

let
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.stable;
in
{
  services.xserver = {
    videoDrivers = [ "nvidia" ];

    # Let Xorg select the display GPU from the active DRM connectors instead of
    # generating a static Device/Screen layout for either MUX mode.
    drivers = lib.mkForce [ ];
    externallyConfiguredDrivers = [ "nvidia" ];
    modules = [ nvidiaPackage.bin ];
  };

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = false;
    };
    open = true;
    nvidiaSettings = true;
    package = nvidiaPackage;
  };

  environment = {
    etc."X11/xorg.conf.d/10-nvidia-autoconfig.conf".text = ''
      Section "OutputClass"
        Identifier "NVIDIA auto configuration"
        MatchDriver "nvidia-drm"
        Driver "nvidia"
        Option "AllowEmptyInitialConfiguration"
      EndSection
    '';

    systemPackages = [
      (pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec "$@"
      '')
    ];
  };
}
