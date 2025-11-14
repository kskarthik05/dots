{
  boot.resumeDevice = "/dev/disk/by-uuid/6b74c9c9-1c4b-4360-9534-daaa94160697";
  boot.kernelParams = [ "resume_offset=43752456" "mem_sleep_default=deep"]; 
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/6b74c9c9-1c4b-4360-9534-daaa94160697";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" ];
  };
  swapDevices = [ { device = "/swap/swapfile"; } ];
  # Suspend first then hibernate when closing the lid
  services.logind.lidSwitch = "suspend-then-hibernate";
  # Hibernate on power button pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateMode=shutdown
    HibernateDelaySec=30m
    SuspendState=mem
  '';

}
