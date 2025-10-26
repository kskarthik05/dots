{ config, pkgs, inputs, ... }: {
  imports = [ 
   ./packages.nix
   ./persistence.nix
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
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/.dots#dellG";
      hms = "NIXPKGS_ALLOW_INSECURE=1 home-manager switch --flake $HOME/.dots#keisuke5 --impure";
      hed = "nano $HOME/.dots/users/$USER/default.nix";
      hep = "nano $HOME/.dots/users/$USER/packages.nix";
      ccd = "cd $HOME/.dots/users/$USER/config";
      cud = "cd $HOME/.dots/users/$USER";
      csd = "cd $HOME/.dots/hosts/dellG";
      nfu = "cd $HOME/.dots/ && git add . && git commit -m \"FLAKE UPDATE\" && git push && sudo nix flake update";
      ncl = "sudo nix-collect-garbage";
      nclf = "sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    };
  };
}
