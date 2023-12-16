{ config, pkgs, ... }: {
  nixpkgs.config = { allowUnfree = true; };
  home.packages = with pkgs; [
    htop
    wineWowPackages.staging
    lutris
    steam
    neofetch
    nicotine-plus
    picard
    steamtinkerlaunch
    git
    nixfmt
    (pkgs.writeShellScriptBin "switchbg" ''
      cp  "$(find ~/Pictures/backgrounds -type f | shuf -n 1)" ~/.background-image
      ${feh}/bin/feh --bg-fill ~/.background-image
      dbus-send --session --dest=org.kde.plasmashell --type=method_call \
      /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
      var Desktops = desktops();
      for (i=0;i<Desktops.length;i++) {
        d = Desktops[i];
        d.wallpaperPlugin = "org.kde.image";
        d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
        d.writeConfig("Image", "file:///home/keisuke5/.background-image");
      }'
    '')

  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
