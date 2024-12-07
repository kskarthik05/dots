{ pkgs, lib, config, ... }:
let
  vfio-start = pkgs.writeShellScriptBin "vfio-start" ''
    sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
    virsh start --domain win11
  '';

  vfio-kill = pkgs.writeShellScriptBin "vfio-kill" ''
    virsh destroy --domain win11
    sudo modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia
  '' 

  gpu-disable = pkgs.writeShellScriptBin "gpu-disable" ''
    sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
  '';

  gpu-enable = pkgs.writeShellScriptBin "gpu-enable" ''
    sudo modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia
  ''

  vm_hook = pkgs.writers.writeBash "vm-hook" ''
    # Variables
    GUEST_NAME="$1"
    OPERATION="$2"
    SUB_OPERATION="$3"

    # Run commands when the vm is started/stopped.
    if [ "$GUEST_NAME" == "win11" ]; then
      if [ "$OPERATION" == "prepare" ]; then
        if [ "$SUB_OPERATION" == "begin" ]; then
          modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
	  looking-glass-client
        fi
      fi

      if [ "$OPERATION" == "release" ]; then
        if [ "$SUB_OPERATION" == "end" ]; then
          modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia
        fi
      fi
    fi
  '';
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
      ovmf.enable = true;
      ovmf.packages = [ pkgs.OVMFFull.fd ];
      swtpm.enable = true;
    };
    hooks.qemu = {
      vm_hook = "${vm_hook}";
    };  
  };
  programs.virt-manager.enable = true;
  systemd.tmpfiles.rules =
    [ "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -" ];
  environment.systemPackages = with pkgs; [
    vfio-start
    vfio-kill
    gpu-enable
    gpu-disable
    scream
    looking-glass-client
    virtiofsd
    nvidia-offload
    killall
    lsof
    psmisc
  ];
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    __EGL_VENDOR_LIBRARY_FILENAMES =
      "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
  fileSystems."/var/lib/libvirt/images" = {
    device = "/nix/persist/var/lib/libvirt/images";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  fileSystems."/var/lib/libvirt/ovmf" = {
    device = "/nix/persist/var/lib/libvirt/ovmf";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  fileSystems."/var/lib/libvirt/qemu" = {
    device = "/nix/persist/var/lib/libvirt/qemu";
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
    securityType = "user";
    settings = {
    global = {
      "workgroup" = "WORKGROUP";
      "server string" = "smbnix";
      "netbios name" = "smbnix";
      "security" = "user";
      #"use sendfile" = "yes";
      #"max protocol" = "smb2";
      # note: localhost is the ipv6 localhost ::1
      "hosts allow" = "192.168.0. 192.168.122. 127.0.0.1 localhost";
      "hosts deny" = "0.0.0.0/0";
      "guest account" = "nobody";
      "map to guest" = "bad user";
      "ntlm auth" = "True";
      "acl allow execute always" = "True";
    };
      "games" = {
        "path" = "/home/keisuke5/Games";
        "browseable" = "yes";
        "writeable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "follow symlinks" = "yes";
        "allow insecure wide links" = "yes";
        "wide links" = "yes";
        "create mask" = "0644";
        "force create mode" = "0644";
        "directory mask" = "0755";
        "force directory mode" = "0755";
    };
    };
  };
  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [ ];
  services.displayManager.defaultSession = lib.mkForce "plasma";
  services.displayManager.sddm.wayland.enable = true;
}

