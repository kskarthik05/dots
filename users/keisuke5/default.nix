{ config, pkgs, ... }: {
  imports = [ ./shell.nix ./packages.nix];
  home.username = "keisuke5";
  home.homeDirectory = "/home/keisuke5";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
