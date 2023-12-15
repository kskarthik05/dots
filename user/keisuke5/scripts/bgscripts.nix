{ pkgs, ... }: {
  pkgs.writeShellApplication = {
    name = "switchbg";
    runtimeInputs = [ pkgs.feh ];
    text = ''
      cp  "$(find ~/Pictures/backgrounds -type f | shuf -n 1)" ~/.background-image
      feh --bg-fill ~/.background-image
    '';
  };
}
