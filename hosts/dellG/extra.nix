{
  imports = [ ./steam.nix ];
  programs.dell-gameshift.enable = true;
  programs.gamemode.enable = true;
  programs.dconf.enable = true;
  programs.kdeconnect.enable = true;
}
