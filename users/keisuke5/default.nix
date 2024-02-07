{ config, pkgs, inputs, ... }: {
  imports = [ 
   ./packages.nix
  ];
  home.username = "keisuke5";
  home.homeDirectory = "/home/keisuke5";
  home.stateVersion = "23.11";
  home.file."${config.xdg.configHome}" = {
    source = ./config;
    recursive = true;
  };
  home.file.".Xresources"={
    source = ./config/Xresources;
  };
  programs.git = {
    enable = true;
    userName  = "Karthik";
    userEmail = "kskarthik20025@gmail.com";
  };
  programs.home-manager.enable = true;
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  dconf.enable = true;
  gtk = with pkgs; {
    enable = true;
    theme = {
      name = "Mint-Y-Dark-Grey";
      package = cinnamon.mint-themes;
    };
    iconTheme = {
      name = "Mint-Y-Grey";
      package = cinnamon.mint-y-icons;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = bibata-cursors;
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/.dots#dellG";
      hms = "home-manager switch --flake $HOME/.dots#keisuke5 --impure";
      hed = "nano $HOME/.dots/users/$USER/default.nix";
      hep = "nano $HOME/.dots/users/$USER/packages.nix";
      ccd = "cd $HOME/.dots/users/$USER/config";
      cud = "cd $HOME/.dots/users/$USER";
      csd = "cd $HOME/.dots/hosts/dellG";
    };
  };
}
