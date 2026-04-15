{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote/v1.0.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations = {
        nixxy = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            # impermanence.nixosModules.impermanence
            home-manager.nixosModules.home-manager
            # inputs.lanzaboote.nixosModules.lanzaboote
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.erik = ./home.nix;
                extraSpecialArgs = { inherit inputs; };
              };
            }
          ];
        };
      };
  };
}
