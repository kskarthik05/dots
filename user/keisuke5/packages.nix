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
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}
