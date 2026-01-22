{ config, pkgs, pkgs-unstable,  inputs, ... }:
#let
#  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
#  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz"); 
#in {
{
  home.packages = with pkgs; 
#with nix-gaming.packages.${pkgs.hostPlatform.system}; 
[ 
    easyeffects
    ventoy
    usbutils
    pciutils
    xclicker
    wget
    unzip
    zenity
    mp3gain
    pkgs-unstable.osu-lazer-bin
    pipewire.jack
#    nur.repos.ataraxiasjel.waydroid-script
    krita
    pciutils
    dconf-editor
    chromium
    universal-android-debloater
    jre
    ffmpeg
    pulseaudio
    firefox
    pavucontrol
    r2modman
    stremio
    xterm
    htop
    vesktop
    neofetch
    nicotine-plus
    picard
    git
    nixfmt-classic
    rhythmbox
    mpv
    transmission_4-gtk
    tree
    flac
    unar
    brightnessctl
    steam-run
    mangohud
    mesa-demos
    steamtinkerlaunch
    #Custom
    (callPackage ../../pkgs/bgScripts.nix { })
  ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ zlib openssl.dev pkg-config]);
  };
}
