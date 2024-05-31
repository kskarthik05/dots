{ pkgs, lib, ... }:
let
  gpuIDs = [
    "10de:25e2" # Graphics
    "10de:2291" # Audio
  ];
in {
  boot = {
    initrd.kernelModules =
      [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    kernelParams =
      [ "intel_iommu=on" ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs) ];
    blacklistedKernelModules = [ "nvidia" "nouveau" ];
  };
  services.xserver.videoDrivers = lib.mkForce [ "modesetting" "fbdev" ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  systemd.tmpfiles.rules =
    [ "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -" ];
  environment.systemPackages = with pkgs; [ looking-glass-client gnome.gnome-remote-desktop ];
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "gnome-remote-desktop";
  services.xrdp.openFirewall = true;
  networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 80 443 3389 ];
  allowedUDPPortRanges = [
    { from = 4000; to = 4007; }
    { from = 8000; to = 8010; }
  ];
};

}
