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
  {
    nixosConfigurations.desktop =
      nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";
        
        specialArgs = {
          pkgs-unstable =
            import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
          };
        };

        modules = [

          ./hosts/desktop

          home-manager.nixosModules.home-manager
          {
            home-manager.users.tippy =
            import ./home/tippy;

            home-manager.extraSpecialArgs = {
              pkgs-unstable =
                import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
              };
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    nixosConfigurations.asus =
      nixpkgs.lib.nixosSystem {

        system = "x86_64-linux";

        specialArgs = {
          pkgs-unstable =
            import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
          };
        };

        modules = [

          ./hosts/asus

          home-manager.nixosModules.home-manager
          {
            home-manager.users.tippy =
            import ./home/tippy;

            home-manager.extraSpecialArgs = {
              pkgs-unstable =
                import nixpkgs-unstable {
                  system = "x86_64-linux";
                  config.allowUnfree = true;
              };
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
  };
}
