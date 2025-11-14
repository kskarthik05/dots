{ config, pkgs, lib, ... }:

let
  repoPath = "$HOME/.dots/users/$USER/dotfiles";  # path to your repo
  pathsToManage = [
    ".config/rofi"
    ".config/waybar"
    ".config/i3"
    ".config/sway"
    ".config/MangoHud"
    ".config/alacritty.toml"
    ".config/picom"
  ];
  dconfDumpPath = "./dumps/dconf";  # where to save dconf
  initFlag = "/org/ksk/custom-dconf-loaded";   # flag key in dconf
in {
  home.packages = [ pkgs.dconf ];

  home.activation.syncToRepoAndDconf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH="${pkgs.dconf}/bin:$PATH"
    set -e
    mkdir -p ${repoPath}

    # --- Sync top-level paths ---
    for p in ${lib.concatStringsSep " " pathsToManage}; do
      src="$HOME/$p"
      dest="${repoPath}/$p"

      if [ -L "$src" ] && [ "$(readlink -f "$src")" = "$dest" ]; then
       # Symlink already exists, skip
       echo "Symlink $src → $dest already exists, skipping"
       continue
      fi
  
      if [ -e "$src" ]; then
        # Path exists in $HOME → copy to repo and replace with symlink
        mkdir -p "$(dirname "$dest")"
        cp -a "$src" "$dest"
        rm -rf "$src"
        ln -sfn "$dest" "$src"
        echo "Synced $src → $dest"
      elif [ -e "$dest" ]; then
        # Path does not exist in $HOME, but exists in repo → create symlink
        mkdir -p "$(dirname "$src")"
        ln -sfn "$dest" "$src"
        echo "Created symlink $src → $dest"
      else
        echo "Skipping $src, path does not exist in $HOME or repo"
      fi
    done

    # --- Dconf sync using flag ---
    if PATH="${pkgs.dconf}/bin:$PATH" dconf read "${initFlag}" &>/dev/null; then
      # Flag exists → update repo dump
      echo "Flag exists, updating repo dconf dump"
      mkdir -p "$(dirname "${dconfDumpPath}")"
      PATH="${pkgs.dconf}/bin:$PATH" dconf dump / > "${dconfDumpPath}" || echo "Warning: dconf dump failed"
    else
      # Flag does not exist
      if [ -f "${dconfDumpPath}" ]; then
        echo "Flag not set, restoring repo dconf dump"
        PATH="${pkgs.dconf}/bin:$PATH" dconf load / < "${dconfDumpPath}" || echo "Warning: dconf load failed"
      else
        echo "No repo dump found, creating a new dump from current host"
        mkdir -p "$(dirname "${dconfDumpPath}")"
        PATH="${pkgs.dconf}/bin:$PATH" dconf dump / > "${dconfDumpPath}" || echo "Warning: dconf dump failed"
      fi

      # Set the initialization flag
      PATH="${pkgs.dconf}/bin:$PATH" dconf write "${initFlag}" "true"
      echo "Initialization flag set at ${initFlag}"
    fi
  '';
}
