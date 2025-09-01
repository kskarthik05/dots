{ pkgs-unstable, ... }:{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
    package = pkgs-unstable.opentabletdriver;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
  ];
  environment.etc = {
    "libinput/local-overrides.quirks".source =
      "/persist/etc/libinput/local-overrides.quirks";
  };
}
