{
  description = "tippy nixos";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url =
      "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url =
        "github:nix-community/home-manager/release-26.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost = hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit pkgs-unstable; };

          modules = [
            hostModule

            home-manager.nixosModules.home-manager
            {
              home-manager.users.tippy = import ./home/tippy;

              home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        desktop = mkHost ./hosts/desktop;
        asus = mkHost ./hosts/asus;
      };
    };
}
