
{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
  ];

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;
  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.udev.packages = lib.singleton (
    pkgs.writeTextDir "lib/udev/rules.d/61-gpu-offload.rules" ''
      SYMLINK=="dri/by-path/pci-0000:00:02.0-card", SYMLINK+="dri/igpu1"
      SYMLINK=="dri/by-path/pci-0000:01:00.0-card", SYMLINK+="dri/dgpu1"
    ''
  );

services.getty = {
  autologinUser = "keisuke5";
  autologinOnce = true;
};
environment.loginShellInit = ''
   
    [[ "$(tty)" == /dev/tty1 ]] && export WLR_DRM_DEVICES=/dev/dri/igpu1 && sway
'';

  programs.light.enable = true;
  users.users.keisuke5.extraGroups = [ "video" ];
}
