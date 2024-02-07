{ pkgs, lib, ... }: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  systemd.tmpfiles.rules =
    [ "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -" ];
  environment.systemPackages = with pkgs; [ 
    looking-glass-client
    podman
    distrobox
  ];
}
