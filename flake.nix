{
  description = "Nice Flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    overlays = (import ./overlays);
    pkgs = import nixpkgs {
      inherit system overlays;
      config = { allowUnfree = true;
                 allowUnfreePredicate = (_: true); };
    };
  in {
    nixosConfigurations.dellG = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs; };
        modules = [
          { nixpkgs.overlays = overlays; }
          ./hosts/dellG
          ./modules/system
        ];
    };
    homeConfigurations = {
      keisuke5 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/keisuke5  ];
          extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
