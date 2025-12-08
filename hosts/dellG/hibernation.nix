{
  boot.resumeDevice = "/dev/disk/by-uuid/6b74c9c9-1c4b-4360-9534-daaa94160697";
  boot.kernelParams = [ "resume_offset=43752456" "mem_sleep_default=deep"]; 
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/6b74c9c9-1c4b-4360-9534-daaa94160697";
    fsType = "btrfs";
    options = [ "subvol=swap" "noatime" ];
  };
  swapDevices = [ { device = "/swap/swapfile"; } ];
}
