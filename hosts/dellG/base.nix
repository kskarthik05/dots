{ config, lib, pkgs-unstable, ... }: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs-unstable.linuxPackages_latest;
  time.timeZone = "Asia/Kolkata";
  environment.etc = { "machine-id".source = "/persist/etc/machine-id"; };
  fileSystems."/var/log" = {
    device = "/persist/var/log";
    fsType = "none";
    options = [ "bind" ];
    neededForBoot = true;
  };
  networking.hostName = "nixos-dellG";
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  system.stateVersion = "23.11";
}

