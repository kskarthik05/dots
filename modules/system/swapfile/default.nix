{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.swapfile;
in {
  options.services.swapfile = with types; {
    enable = mkEnableOption "Enable swapfile";
    size = mkOption {
      type = int;
      description = "Swapfile size";
      default = "2";
    };
    swappiness = mkOption {
      type = int;
      description = "Swapfile swappiness";
      default = "60";
    };
    path = mkOption {
      type = path;
      description = "Swapfile path";
      default = "/swapfile";
    };
  };
  config = mkIf cfg.enable {
    systemd.services.create-swapfile = {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "swap-swapfile.swap" ];
      script = ''
        ${pkgs.coreutils}/bin/truncate -s 0 ${cfg.path}
        ${pkgs.e2fsprogs}/bin/chattr +C ${cfg.path}
        ${pkgs.btrfs-progs}/bin/btrfs property set ${cfg.path} compression none
      '';
    };
    swapDevices = [{
      device = cfg.path;
      size = (1024 * cfg.size);
    }];
    boot.kernel.sysctl = { "vm.swappiness" = cfg.swappiness; };
  };
}
