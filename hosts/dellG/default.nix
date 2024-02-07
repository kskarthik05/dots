{
  imports = [ ./base.nix ./hardware.nix ];
  specialisation = {
    clamshell.configuration = { imports = [ ./clamshell.nix ]; };
    on-the-go.configuration = { imports = [ ./on-the-go.nix ]; };
    vfio.configuration = { imports = [ ./vfio.nix ]; };
    base-with-vm.configuration = { imports = [ ./base-with-vm.nix ]; };
  };
}