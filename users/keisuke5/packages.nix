{ config, pkgs, pkgs-lutris-pin, pkgs-unstable, inputs, ... }:
let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz"); 
in {
  home.packages = with pkgs; with nix-gaming.packages.${pkgs.hostPlatform.system}; [
    soundkonverter
    mp3gain
#    nix-gaming.packages.${pkgs.hostPlatform.system}.osu-stable
#    osu-lazer-bin
#    inputs.etterna.packages.x86_64-linux.etterna
    pipewire.jack
    pkgs-unstable.discord-canary
    nur.repos.ataraxiasjel.waydroid-script
    krita
    pciutils
    gnome.dconf-editor
    distrobox
    chromium
    pkgs-unstable.universal-android-debloater
    jre
    ffmpeg
    pulseaudio
    pkgs-unstable.lutris
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
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ zlib openssl.dev pkg-config]);
  };
}
