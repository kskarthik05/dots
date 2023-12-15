{ config, pkgs, ... }: {
  nixpkgs.config = { allowUnfree = true; };
  home.packages = [
    pkgs.htop
    pkgs.wineWowPackages.staging
    pkgs.lutris
    pkgs.steam
    pkgs.neofetch
    pkgs.nicotine-plus
    pkgs.picard
    pkgs.steamtinkerlaunch
    pkgs.git
    pkgs.nixfmt
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
