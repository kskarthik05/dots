{ pkgs-lutris-pin, ... }:{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
    package = pkgs-lutris-pin.opentabletdriver;
  };
  environment.etc = {
    "libinput/local-overrides.quirks".source =
      "/nix/persist/etc/libinput/local-overrides.quirks";
  };
}
