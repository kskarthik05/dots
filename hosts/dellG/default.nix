{
  imports = [ ./base.nix ./hardware.nix ];
  specialisation = {
    on-the-go.configuration = { imports = [ ./on-the-go.nix ]; };
    vfio.configuration = { imports = [ ./vfio.nix ]; };
    base-with-vm.configuration = { imports = [ ./base-with-vm.nix ]; };
  };
}
