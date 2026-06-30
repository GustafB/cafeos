{
  description = "cafebabe os";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:

    let
      username = "cafebabe";

      # Build a NixOS system for a host directory under ./hosts.
      # Each host carries its own variables.nix (see `vars`), which drives
      # feature toggles such as `vars.gui` so the same module tree can target
      # a full desktop or a headless WSL install.
      mkHost =
        {
          host,
          system ? "x86_64-linux",
        }:
        let
          vars = import ./hosts/${host}/variables.nix;
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              system
              username
              host
              vars
              ;
          };
          modules = [
            ./hosts/${host}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit
                  inputs
                  username
                  host
                  vars
                  ;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ];
        };
    in

    {
      devShells."x86_64-linux".default =
        nixpkgs.legacyPackages."x86_64-linux".mkShell {
          packages = with nixpkgs.legacyPackages."x86_64-linux"; [
          ];
        };

      nixosConfigurations = {
        desktop = mkHost { host = "desktop"; };
        wsl = mkHost { host = "wsl"; };
        # laptop is still on the pre-refactor layout; migrate it to the shared
        # module tree (mirror hosts/desktop) before re-enabling it here.
      };
    };
}
