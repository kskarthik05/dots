{ lib, ... }: {
  hardware.nvidia.prime.sync.enable = lib.mkForce false;
  boot.kernelParams = [ "module_blacklist=i915" ];
}
