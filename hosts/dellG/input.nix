{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
  };
  environment.etc = {
    "libinput/local-overrides.quirks".source =
      "/nix/persist/etc/libinput/local-overrides.quirks";
  };
}
