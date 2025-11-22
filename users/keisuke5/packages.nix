{ config, pkgs, pkgs-stable, pkgs-lutris-pin,  inputs, ... }:
let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz"); 
in {
  home.packages = with pkgs; with nix-gaming.packages.${pkgs.hostPlatform.system}; [ 
    usbutils
    pciutils
    clipman
    font-awesome
    waybar
    networkmanagerapplet
    rofi
    xfce.thunar
    pasystray
    i3status
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    xclicker
    wget
    unzip
    zenity
    mp3gain
#    nix-gaming.packages.${pkgs.hostPlatform.system}.osu-stable
    pkgs-stable.osu-lazer-bin
    etterna
    pipewire.jack
    discord
#    nur.repos.ataraxiasjel.waydroid-script
    krita
    pciutils
    dconf-editor
    distrobox
    chromium
    universal-android-debloater
    jre
    ffmpeg
    pulseaudio
    lutris
    wineWowPackages.staging
    firefox
    pavucontrol
    r2modman
    pkgs-stable.stremio
    obs-studio
    xterm
    htop
    vesktop
    neofetch
    nicotine-plus
    picard
    git
    nixfmt-classic
#   rhythmbox
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
