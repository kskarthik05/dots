{ config, lib, pkgs, pkgs-unstable, inputs, ... }: {

  #Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;

  #Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;

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
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  #Swap
  services.swapfile = {
    enable = true;
    path = "/nix/persist/swapfile";
    size = 12;
    swappiness = 1;
  };

  #Power
#  services.thermald.enable = true;
#  services.auto-cpufreq.enable = true;
#  services.auto-cpufreq.settings = {
#    battery = {
#      governor = "powersave";
#      turbo = "never";
#    };
#    charger = {
#      governor = "performance";
#      turbo = "auto";
#    };
#  };

  #Network
  networking.networkmanager.enable = true;

  #Services
  programs.dell-gameshift.enable = true;
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = false;
  };
  programs.dconf.enable = true;

  #Users
  users.mutableUsers = false;
  users.users.keisuke5 = {
    home = "/home/keisuke5";
    initialHashedPassword =
      "$6$ZKqa0w3vM1rX9f1W$GvWMBomAs1pSgwQ2C6p8DZg5tvOdGNIxks7RpPUcIY9Rnf.aLH3kBPkEts28FFfPtkHXtTM.q0JkXP.u5m4NC0";
    isNormalUser = true;
    extraGroups =
      [ "wheel" "power" "video" "docker" "vboxusers" "libvirtd" "qemu-libvirtd" ];
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

  #Nixos
  networking.hostName = "nixos-dellG";
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  system.stateVersion = "23.11";
}

