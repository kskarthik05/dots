{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; } , stdenv ? pkgs.stdenv, lib ? pkgs.lib }:
let
  runtimeInputs= with pkgs; [ feh glib libnotify ];
  getosubg = pkgs.writeShellApplication {
    name = "getosubg";
    inherit runtimeInputs;
    text = ''
      search_directory="$HOME/Games/osu!/Songs"
      if [ ! -d "$search_directory" ]; then
        echo "The specified directory does not exist."
        exit 1
      fi

      # Function to compute SHA1 checksum
      calculate_checksum() {
        sha1sum "$1" | awk '{print $1}'
      }

      # Function to find a unique background
      find_unique_background() {
        while true; do
          random_subdirectory=$(find "$search_directory" -maxdepth 1 -mindepth 1 -type d | shuf -n 1)
          random_osu_file=$(find "$random_subdirectory" -type f -name "*.osu" | shuf -n 1)
          bg_string=$(awk '/\[Events\]/{flag=1; next} flag && NF{count++; if (count == 2 || count == 3) {if ($0 ~ /"([^"]+\.(jpg|png|jpeg))"/) {print $0; exit}}}' "$random_osu_file")
          extracted_text=$(echo "$bg_string" | grep -o '".*"' | sed 's/"//g')
          bg_path="$random_subdirectory/$extracted_text"
          checksum=$(calculate_checksum "$bg_path")

          # Check if a file named by the checksum exists in $HOME/Pictures/backgrounds/
          if [ ! -f "$HOME/Pictures/backgrounds/$checksum" ]; then
            return
          fi
        done
      }

      # Find a unique background
      unique_bg_path=$(find_unique_background)

      # Set the background image
      cp "$unique_bg_path" ~/".background-image"
      feh --bg-fill ~/.background-image
      gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.background-image"
      gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.background-image"
 '';
  };
  savebg = pkgs.writeShellApplication {
    name = "savebg";
    inherit runtimeInputs;
    text = ''
      cp ~/.background-image ~/Pictures/backgrounds/"$(sha1sum ~/.background-image | awk '{print $1}')"
      notify-send "saved"  
    '';
  };
  switchbg = pkgs.writeShellApplication {
    name = "switchbg";
    inherit runtimeInputs;
    text = ''
      cp  "$(find ~/Pictures/backgrounds -type f | shuf -n 1)" ~/.background-image
      feh --bg-fill ~/.background-image
      gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/.background-image"
      gsettings set org.gnome.desktop.background picture-uri "file://$HOME/.background-image"
    '';
  };
in stdenv.mkDerivation {
  pname = "bgScripts";
  version = "0.0.1";
  phases = [ "installPhase" ];
  buildInputs = runtimeInputs;
  installPhase = ''
    mkdir -p $out/bin
    cd $out/bin
    cp {${getosubg}/bin/getosubg,${savebg}/bin/savebg,${switchbg}/bin/switchbg} .
  '';
  meta = with lib; {
    description = "Some nice scripts for changing desktop bg";
    platforms = with platforms; linux ++ darwin;
  };
}
  
