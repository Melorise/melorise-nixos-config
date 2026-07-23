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

    codex-desktop-linux-builder.url =
      "github:Melorise/codex-desktop-linux-builder/nix";
  };


  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-thirdParty = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (_final: _prev: {
            codex-desktop =
              inputs.codex-desktop-linux-builder.packages.${system}.codex-desktop;
          })
        ];
      };

      mkHost = hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit pkgs-unstable pkgs-thirdParty; };

          modules = [
            hostModule

            home-manager.nixosModules.home-manager
            {
              home-manager.users.tippy = import ./home/tippy;

              home-manager.extraSpecialArgs = {
                inherit pkgs-unstable pkgs-thirdParty;
              };
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
