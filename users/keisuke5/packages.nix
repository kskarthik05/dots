{ config, pkgs, pkgs-unstable, inputs, ... }:
{
  home.packages = with pkgs; [
    gnome.dconf-editor
    distrobox
    libreoffice-fresh
    chromium
    pkgs-unstable.universal-android-debloater
    jre
    ffmpeg
    pulseaudio
    lutris
    pkgs-unstable.wineWowPackages.staging
    firefox
    pavucontrol
    r2modman
    stremio
    obs-studio
    xterm
    htop
    pkgs-unstable.discord
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
