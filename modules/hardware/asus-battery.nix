{ ... }:

{
  systemd.services.asus-battery-charge-limit = {
    description = "Set ASUS battery charge limit to 80%";
    wantedBy = [ "multi-user.target" ];
    wants = [ "systemd-udev-settle.service" ];
    after = [
      "systemd-modules-load.service"
      "systemd-udev-settle.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      threshold=/sys/class/power_supply/BAT0/charge_control_end_threshold

      if ! printf '80\n' > "$threshold"; then
        echo "Failed to set ASUS BAT0 charge limit to 80%: $threshold" >&2
        exit 1
      fi

      if ! read -r actual < "$threshold"; then
        echo "Failed to read ASUS BAT0 charge limit: $threshold" >&2
        exit 1
      fi

      if [ "$actual" != "80" ]; then
        echo "ASUS BAT0 charge limit verification failed: expected 80%, got $actual%" >&2
        exit 1
      fi

      echo "ASUS BAT0 charge limit verified: $actual%"
    '';
  };
}
