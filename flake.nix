let
  thirdPartyCaches = {
    clash-party = {
      substituter = "https://melorise-cp-nix.cachix.org";
      publicKey = "melorise-cp-nix.cachix.org-1:GNg96VizkktTdGMrvl6+PLPHY3jPce4a72HqP2cj4S4=";
    };
    codex-desktop = {
      substituter = "https://melorise-codex-desktop.cachix.org";
      publicKey = "melorise-codex-desktop.cachix.org-1:PN32aGXkz7tWwvCuwQfKo3/P/dOG/oa8mS8y58pdB5U=";
    };
  };
  cacheEntries = builtins.attrValues thirdPartyCaches;
  cacheSubstituters = map (cache: cache.substituter) cacheEntries;
  cachePublicKeys = map (cache: cache.publicKey) cacheEntries;
in
{
  description = "tippy nixos";

  nixConfig = {
    extra-substituters = cacheSubstituters;
    extra-trusted-public-keys = cachePublicKeys;
  };

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

    amber-pm.url = "git+https://gitee.com/Melorise/amber-pm.git?ref=nixos";

    clash-party.url = "git+https://github.com/Melorise/cp-nix.git?ref=main";

    codex-desktop.url = "git+https://github.com/Melorise/codex-desktop-linux-builder.git?ref=nix";

    spark-store = {
      url = "git+https://gitee.com/Melorise/spark-store.git?ref=nixos";
      flake = false;
    };

    spark-winfonts.url = "git+https://github.com/Melorise/spark-winfonts-for-nixos.git?ref=main";

    npanel.url = "github:Melorise/nPanel/nixos-26.05/v2.0.1";
  };


  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      thirdPartyOverlays = [
        inputs.amber-pm.overlays.default
        inputs.spark-winfonts.overlays.default
        (_final: _prev: {
          clash-party = inputs.clash-party.packages.${system}.clash-party;
        })
        (_final: _prev: {
          codex-desktop = inputs.codex-desktop.packages.${system}.codex-desktop;
        })
        (final: _prev: {
          spark-store = final.callPackage "${inputs.spark-store}/nix/package.nix" {
            apm = final.amber-pm;
          };
        })
      ];
      pkgs-thirdParty = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = thirdPartyOverlays;
      };

      thirdPartyNixosModules = [
        inputs.amber-pm.nixosModules.default
        inputs.clash-party.nixosModules.clash-party
      ];

      thirdPartyCacheModule = {
        nix.settings = {
          substituters = cacheSubstituters;
          trusted-public-keys = cachePublicKeys;
        };
      };

      mkHost = hostModule:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs pkgs-unstable pkgs-thirdParty; };

          modules =
            [
              hostModule
              thirdPartyCacheModule
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
