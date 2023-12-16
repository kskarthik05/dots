{ config, lib, pkgs, ... }: {
  imports = [
    ./boot.nix
    ./fs.nix
    ./users.nix
    ./graphics.nix
    ./network.nix
    ./locale.nix
    ./services.nix
    ../../modules/nixos/graphics/nvidia-optimus-stable.nix
    ../../modules/nixos/kernel/linux_latest.nix
    ../../modules/nixos/desktop/plasma.nix
    ../../modules/nixos/sound/pipewire.nix
    ../../modules/nixos/input/otd.nix
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "23.11";

}

