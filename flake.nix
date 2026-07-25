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

    codex-desktop-linux-builder.url =
      "github:Melorise/codex-desktop-linux-builder/nix";

    cp-nix = {
      url = "github:Melorise/cp-nix";
    };

    # Amber PM 本身提供 Flake package 与 NixOS module。
    amber-pm = {
      url = "git+https://gitee.com/Melorise/amber-pm.git?ref=nixos";
    };

    # Spark Store 尚未提供 Flake outputs，仅将远程仓库作为固定源码输入。
    spark-store-src = {
      url = "git+https://gitee.com/Melorise/spark-store.git?ref=nixos";
      flake = false;
    };
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
          (final: _prev: {
            codex-desktop =
              inputs.codex-desktop-linux-builder.packages.${system}.codex-desktop;

            clash-party =
              inputs.cp-nix.packages.${system}.clash-party;

            amber-pm =
              inputs.amber-pm.packages.${system}.amber-pm;

            # Spark Store 不是 Flake，直接从源码 input 调用其 Nix 包表达式。
            spark-store =
              final.callPackage
                "${inputs.spark-store-src}/nix/package.nix"
                {
                  apm = final.amber-pm;
                };
          })
        ];
      };

      thirdPartyNixosModules =
        map
          (name: inputs.${name}.nixosModules.default)
          [
            "amber-pm"
            "cp-nix"
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
