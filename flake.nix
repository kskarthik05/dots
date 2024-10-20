{
  description = "Nice Flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    overlays = (import ./overlays);
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.dellG = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs pkgs-unstable; };
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
          extraSpecialArgs = { inherit inputs outputs pkgs-unstable; };
      };
    };
  };
}
