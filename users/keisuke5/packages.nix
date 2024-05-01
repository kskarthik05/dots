{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    jre
    ffmpeg
    pulseaudio
    lutris
    wineWowPackages.wayland
    firefox
    pavucontrol
    r2modman
    stremio
    simplescreenrecorder
    xterm
    htop
    discord
    neofetch
    nicotine-plus
    picard
    git
    nixfmt
    rhythmbox
    mpv
    transmission-gtk
    tree
    dunst
    flac
    unar
    brightnessctl
    steam
    steam-run
    mangohud
    glxinfo
    steamtinkerlaunch
    #Custom
    (callPackage ../../pkgs/bgScripts.nix { })
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ zlib openssl.dev pkg-config]);
  };
}
