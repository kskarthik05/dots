{ pkgs, ... }:{
  pkgs.writeShellScriptBin "switchbg" ''
   cp  "$(find ~/Pictures/backgrounds -type f | shuf -n 1)" ~/.background-image
   ${pkgs.feh}/bin/feh --bg-fill ~/.background-image
  ''
}