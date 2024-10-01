{
  description = "cafebabe os";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    let
      system = "aarch64-linux";
      host = "laptop";
      username = "cafebabe";
    in

    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        "${host}" = nixpkgs.lib.nixosSystem {
            modules = [
                home-manager.nixosModules.home-manager
                {
                    home-manager.extraSpecialArgs = {
                        inherit username;
                        inherit inputs;
                        inherit host;
                    };
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.backupFileExtension = "backup";
                    home-manager.users.${username} = import ./hosts/${host}/home.nix;
                }
            ];
        };
    };
  };
}
