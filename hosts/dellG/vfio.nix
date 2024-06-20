{ pkgs, pkgs-unstable, lib, config, ... }:
let
  gpuIDs = [
    "10de:25e2" # Graphics
    "10de:2291" # Audio
  ];
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  disable-gpu = pkgs.writeShellScriptBin "disable-gpu" ''
    sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia
    sudo virsh nodedev-detach pci_0000_01_00_0
    sudo virsh nodedev-detach pci_0000_01_00_1
  '';
  enable-gpu = pkgs.writeShellScriptBin "enable-gpu" ''
    sudo virsh nodedev-reattach pci_0000_01_00_0
    sudo virsh nodedev-reattach pci_0000_01_00_1
    sudo modprobe -i nvidia_drm nvidia_modeset nvidia_uvm nvidia
  '';
  boot-win11vm = pkgs.writeShellScriptBin "boot-win11vm" ''
    sudo systemctl restart samba-winbindd
    sudo systemctl restart samba-smbd
    sudo systemctl restart samba-nmbd
    virsh -c qemu:///system start win11 && scream -i virbr0 -u -p 4011
  '';
  kill-win11vm = pkgs.writeShellScriptBin "kill-win11vm" ''
    sudo systemctl stop samba-winbindd
    sudo systemctl stop samba-smbd
    sudo systemctl stop samba-nmbd
    sudo systemctl stop 
    virsh -c qemu:///system destroy win11
    killall scream
  '';
in {
  boot = {
    kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    kernelParams = [ "intel_iommu=on" ];
    blacklistedKernelModules = [ "nouveau" ];
  };
  hardware.nvidia.prime = {
    sync.enable = lib.mkForce false;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
  boot.extraModprobeConfig = ''
    options nvidia_drm modeset=0
  '';
  services.xserver.serverFlagsSection = ''
    Option "AutoAddGPU" "false"
  '';
virtualisation.libvirtd = {
  enable = true;
  qemu = {
    runAsRoot = false;
    swtpm.enable = true;
  };
};
  programs.virt-manager.enable = true;
  systemd.tmpfiles.rules =
    [ "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -" ];
  environment.systemPackages = with pkgs; [
    scream
    looking-glass-client
    virtiofsd
    nvidia-offload
    enable-gpu
    disable-gpu
    boot-win11vm
    kill-win11vm
    killall
    lsof
    psmisc
    swtpm
  ];
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    __EGL_VENDOR_LIBRARY_FILENAMES =
      "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
  fileSystems."/var/lib/libvirt" = {
    device = "/nix/persist/var/lib/libvirt";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  fileSystems."/var/lib/samba" = {
    device = "/nix/persist/var/lib/samba";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  services.samba = {
    enable = true;
    openFirewall = true;
    extraConfig = ''
      security = user
      server string = smbnix
      netbios name = smbnix
      usershare allow guests = yes
      bind interfaces only = yes
      interfaces = virbr0
      map to guest = bad user
      force user = keisuke5
      acl allow execute always = True
    '';
    shares = {
      games = {
        path = "/home/keisuke5/Games";
        browseable = "yes";
        writeable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "follow symlinks" = "yes";
        "allow insecure wide links" = "yes";
        "wide links" = "yes";
        "create mask" = 644;
        "force create mode" = 644;
        "directory mask" = 755;
        "force directory mode" = 755;
      };
    };
  };
  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [ ];
}

