{
  description = "tippy nixos";

  inputs = {
    nixpkgs.url =
      #"github:NixOS/nixpkgs/nixos-26.05";
      git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-26.05&shallow=1;

    nixpkgs-unstable.url =
      #"github:NixOS/nixpkgs/nixos-unstable";
      git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1;

    home-manager = {
      url =
        "github:nix-community/home-manager/release-26.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    mnpr.url = "github:Melorise/MNPR/unstable";
  };


  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      thirdPartyOverlays = [
        (_final: _prev:
          inputs.mnpr.packages.${system}
        )
      ];
      pkgs-thirdParty = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = thirdPartyOverlays;
      };

      thirdPartyNixosModules =
        map
          (name: inputs.mnpr.nixosModules.${name})
          [
            "amber-pm"
            "clash-party"
          ];

      mkHost = hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit pkgs-unstable pkgs-thirdParty; };

          modules =
            [
              hostModule
              inputs.mnpr.nixosModules.caches
            ]
            ++ thirdPartyNixosModules
            ++ [
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
