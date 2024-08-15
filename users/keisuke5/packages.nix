{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
in {
  home.packages = with pkgs; [
    vscode.fhs
    slack
    zoom-us
    mp3info
    pkgs-unstable.osu-lazer-bin
    discord
    nur.repos.ataraxiasjel.waydroid-script
    krita
    pciutils
    gedit
    gnome.dconf-editor
    distrobox
    chromium
    pkgs-unstable.universal-android-debloater
    jre
    ffmpeg
    pulseaudio
    firefox
    pavucontrol
    r2modman
    stremio
    obs-studio
    xterm
    htop
    vesktop
    neofetch
    nicotine-plus
    picard
    git
    nixfmt
    rhythmbox
    mpv
    transmission-gtk
    tree
    flac
    unar
    brightnessctl
    steam-run
    mangohud
    glxinfo
    steamtinkerlaunch
    #Custom
    (callPackage ../../pkgs/bgScripts.nix { })
  ];
}
