{
  description = "tippy nixos";

  inputs = {
    nixpkgs.url =
      "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url =
        "github:nix-community/home-manager";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, home-manager, ... }:
  {
    nixosConfigurations.desktop =
      nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";

        modules = [

          ./hosts/desktop/configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.users.tippy =
              import ./home/tippy.nix;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    nixosConfigurations.asus =
      nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";

        modules = [

          ./hosts/asus/configuration.nix

          home-manager.nixosModules.home-manager

          {
            home-manager.users.tippy =
              import ./home/tippy.nix;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
  };
}
