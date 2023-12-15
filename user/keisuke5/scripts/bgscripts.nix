{ pkgs, ... }:{
  pkgs.writeShellApplication {
  name = "switchbg";

  runtimeInputs = [ curl w3m ];

  text = ''
    cp  "$(find ~/Pictures/backgrounds -type f | shuf -n 1)" ~/.background-image
    feh --bg-fill ~/.background-image
  '';
  };
}