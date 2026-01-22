{ config, lib, pkgs, ... }: {
  boot.loader.systemd-boot.enable = true;
#  boot.kernelPackages = pkgs.linuxPackages-rt_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  time.timeZone = "Asia/Kolkata";
  networking.hostName = "nixos-dellG";
  nixpkgs.config.allowBroken = true; 
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  system.stateVersion = "23.11";
}

