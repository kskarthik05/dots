{ config, lib, pkgs, ... }:
with lib;
let
  gameshift-toggle = pkgs.writeShellScriptBin "gameshift-toggle" ''
    STATE_FILE="/tmp/.gmode-state"
    if [ -e "$STATE_FILE" ]; then
      echo "\_SB.AMWW.WMAX 0 0x15 {1, 0xa0, 0x00, 0x00}" > /proc/acpi/call
      echo "\_SB.AMWW.WMAX 0 0x25 {1, 0x00, 0x00, 0x00}" > /proc/acpi/call
      echo "GameShift has been turned off"
      rm $STATE_FILE
    else
      echo "\_SB.AMWW.WMAX 0 0x15 {1, 0xab, 0x00, 0x00}" > /proc/acpi/call
      echo "\_SB.AMWW.WMAX 0 0x25 {1, 0x01, 0x00, 0x00}" > /proc/acpi/call
      echo "GameShift has been turned on"
      touch $STATE_FILE
    fi
  '';
in {
  options.programs.dell-gameshift = {
    enable = mkEnableOption "Enable GameShift toggle for dell G15 5520 Laptops";
  };
  config = mkIf config.programs.dell-gameshift.enable {
    boot.kernelModules = [ "acpi_call" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    environment.systemPackages = [ gameshift-toggle ];
  };
}
