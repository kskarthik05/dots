{ config, pkgs, pkgs-unstable, inputs, ... }:
let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz"); 
in {
  home.packages = with pkgs; [
    soundkonverter
    pipewire.jack
    discord
    nur.repos.ataraxiasjel.waydroid-script
    pkgs-unstable.osu-lazer-bin
    krita
    pciutils
    gnome.dconf-editor
    distrobox
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
    dunst
    flac
    tagger
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
