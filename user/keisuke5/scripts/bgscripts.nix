{ pkgs, ... }: {
  pkgs.writeShellApplication = {
    name = "switchbg";
    text = ''
      cp  "$(find ~/Pictures/backgrounds -type f | shuf -n 1)" ~/.background-image
      feh --bg-fill ~/.background-image
    '';
  };
}
