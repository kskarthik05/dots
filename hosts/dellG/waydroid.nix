{ lib, ... }: {
  virtualisation.waydroid.enable = true;
  fileSystems."/var/lib/waydroid" = {
    device = "/nix/persist/var/lib/waydroid";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  systemd.services.waydroid-container.wantedBy = lib.mkForce [ ];
}
