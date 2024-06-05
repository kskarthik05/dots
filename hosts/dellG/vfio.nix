{ pkgs, lib, config, ... }:
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
in {
  boot = {
  #  initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" ];
    kernelParams =
      [ 
        "intel_iommu=on" 
        #("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs) 
      ];
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
  };
  programs.virt-manager.enable = true;
  systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -" 
  ];
  environment.systemPackages = with pkgs; [ scream looking-glass-client virtiofsd nvidia-offload killall lsof psmisc ];
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
    __EGL_VENDOR_LIBRARY_FILENAMES="/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME="mesa";
  };
  fileSystems."/var/lib/libvirt" = {
    device = "/nix/persist/var/lib/libvirt";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  fileSystems."/var/lib/waydroid" = {
    device = "/nix/persist/var/lib/waydroid";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  virtualisation.waydroid.enable = true;
  services.samba = {
  enable = true;
  securityType = "user";
  openFirewall = true;
  extraConfig = ''
    server string = smbnix
    netbios name = smbnix
    security = user 
    usershare allow guests = yes
    bind interfaces only = yes
    interfaces = virbr0
    guest account = nobody
    map to guest = bad user
    force user = keisuke5
    ntlm auth = true
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
      "create mask" = 0644;
      "force create mode" = 0644;
      "directory mask" = 0755;
      "force directory mode" = 0755;
    };
  };
  };
}

