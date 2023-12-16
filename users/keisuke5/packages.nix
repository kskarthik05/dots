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
    '')

  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
