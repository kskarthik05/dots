{ config, pkgs, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = {
      hms = "home-manager switch --flake $HOME/.dots";
      nrs = "sudo nixos-rebuild switch --flake $HOME/.dots";
    };
    sessionVariables = { NIXPKGS_ALLOW_UNFREE = "1"; };
  };

}
