{
  description = "Nice Flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
  };
  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in {
      nixosConfigurations = {
        nixos-dellG = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/nixos-dellG ];
        };
      };
      homeConfigurations = {
        keisuke5 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/keisuke5 ];
        };
      };
    };
}

