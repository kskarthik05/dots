{ pkgs-unstable, ... }:{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
    package = pkgs-unstable.opentabletdriver;
  };
  environment.etc = {
    "libinput/local-overrides.quirks".source =
      "/nix/persist/etc/libinput/local-overrides.quirks";
  };
}
