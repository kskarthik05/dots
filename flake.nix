{
  description = "Nice Flake";
  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nixpkgs-stable,  home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    overlays = (import ./overlays);
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system overlays;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.dellG = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs outputs pkgs-stable; };
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
          extraSpecialArgs = { inherit inputs outputs pkgs-stable; };
      };
    };
  };
}
