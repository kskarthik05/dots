{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-6.0.36"
  ];
  environment.etc = {
    "libinput/local-overrides.quirks".source =
      "/persist/etc/libinput/local-overrides.quirks";
  };
  services.udev.extraRules = ''
    # Allow keyboard access to web driver, replace ids as needed. 
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", TAG+="uaccess"
  '';
}
