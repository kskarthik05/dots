{ config, pkgs, lib, ... }:
{
  services.xserver.enable = true;
  services.displayManager.sddm={
    enable = true;
    autoLogin.enable = true;
    autoLogin.user = "keisuke5"; 
  };
  services.desktopManager.plasma6.enable = true;
  #services.displayManager.defaultSession = "plasmax11";  
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";
  environment.sessionVariables."KWIN_DRM_NO_AMS"=1;
}
