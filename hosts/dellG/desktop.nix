
{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasmax11";
  environment.sessionVariables = {
    "KWIN_DRM_NO_AMS"=1;
  };
}
