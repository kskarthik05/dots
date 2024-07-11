{ config, pkgs, inputs, ... }: {
  imports = [ 
   ./packages.nix
  ];
  home.username = "keisuke5";
  home.homeDirectory = "/home/keisuke5";
  home.stateVersion = "23.11";
  programs.git = {
    enable = true;
    userName  = "Karthik";
    userEmail = "kskarthik20025@gmail.com";
  };
  programs.home-manager.enable = true;
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
