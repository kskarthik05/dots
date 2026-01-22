{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
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
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", TAG+="uaccess"
    KERNEL=="usb*", SUBSYSTEM=="usb", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="211a", TAG+="uaccess"
  '';
}
