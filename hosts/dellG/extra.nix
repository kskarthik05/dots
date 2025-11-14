{
  imports = [ ./steam.nix ];
  programs.dell-gameshift.enable = true;
  programs.adb.enable = true;
  programs.gamemode.enable = true;
  programs.dconf.enable = true;
}
