{ config, lib, pkgs, inputs, ... }: {

  #Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages-rt_latest;

  #Desktop
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ rofi i3status i3lock ];
    };
    excludePackages = [ pkgs.xterm ];
  };

  #Sound
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #Video
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  #Swap
  systemd.services = {
    create-swapfile = let
      swapPath = "/nix/persist/swapfile"; 
    in {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "swap-swapfile.swap" ];
      script = ''
        ${pkgs.coreutils}/bin/truncate -s 0 ${swapPath}
        ${pkgs.e2fsprogs}/bin/chattr +C ${swapPath}
        ${pkgs.btrfs-progs}/bin/btrfs property set ${swapPath} compression none
      '';
    };
  };
  swapDevices = [{
    device = "/nix/persist/swapfile";
    size = (1024 * 12);
  }];
  boot.kernel.sysctl = { "vm.swappiness" = 1; };

  #Power
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  #Network
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    0.0.0.0 overseauspider.yuanshen.com
    0.0.0.0 log-upload-os.hoyoverse.com

    0.0.0.0 log-upload.mihoyo.com
    0.0.0.0 uspider.yuanshen.com
    0.0.0.0 sg-public-data-api.hoyoverse.com

    0.0.0.0 prd-lender.cdp.internal.unity3d.com
    0.0.0.0 thind-prd-knob.data.ie.unity3d.com
    0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
    0.0.0.0 cdp.cloud.unity3d.com
    0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com
  '';

  #Services
  programs.dell-gameshift.enable = true;
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
  };
  programs.dconf.enable = true;

  #Hooks
  systemd.services.customHooks = let
    scriptDir = ../../scripts;
  in {
    before = [ "shutdown.target" "reboot.target" ];
    description = "Run various custom startup and shutdown hooks";
    serviceConfig = {
      ExecStart = ''
        for script in ${scriptDir}/startup; do
          bash $script
        done
      '';
      ExecStop = ''
        for script in ${scriptDir}/shutdown; do
          bash $script
        done
      '';
    };
  };

  #Global Packages
  environment.systemPackages = with pkgs; [
    pulseaudio
    pavucontrol
    lutris
    wineWowPackages.staging
    firefox
  ];

  #Users
  users.mutableUsers = false;
  users.users.keisuke5 = {
    home = "/home/keisuke5";
    initialHashedPassword =
      "$6$ZKqa0w3vM1rX9f1W$GvWMBomAs1pSgwQ2C6p8DZg5tvOdGNIxks7RpPUcIY9Rnf.aLH3kBPkEts28FFfPtkHXtTM.q0JkXP.u5m4NC0";
    isNormalUser = true;
    extraGroups =
      [ "wheel" "video" "docker" "vboxusers" "libvirtd" "qemu-libvirtd" ];
  };
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "keisuke5";
  };

  #Locale
  time.timeZone = "Asia/Kolkata";

  #Persistance
  systemd.tmpfiles.rules = [
    "L /var/lib/bluetooth - - - - /nix/persist/var/lib/bluetooth"
    "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    "f /dev/shm/looking-glass 0660 keisuke5 qemu-libvirtd -"
  ];
  environment.etc = {
    "machine-id".source = "/nix/persist/etc/machine-id";
    "libinput/local-overrides.quirks".source =
      "/nix/persist/etc/libinput/local-overrides.quirks";
    "NetworkManager/system-connections".source =
      "/nix/persist/etc/NetworkManager/system-connections";
  };
  fileSystems."/var/log" = {
    device = "/nix/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  fileSystems."/var/lib/libvirt" = {
    device = "/nix/persist/var/lib/libvirt";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };

  #Nixos
  networking.hostName = "nixos-dellG";
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  system.stateVersion = "23.11";
}

