{
  description = "Build Vector Tilesets and Serve with Styles, fonts, and sprites via Nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }: let
    buildForSystem = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      self' = pkgs.callPackage ./scope.nix { makeScope = pkgs.lib.makeScope; };

      metadataFnFn = config: tilesUrl:
        self'.buildTilesMetadata {
          tileJson = {tiles = [tilesUrl];};
          tiles = self'.buildTiles {
            inherit config;
            inherit (self'.massachusetts) name;
            renumber = true;
            src = self'.massachusetts;
          };
        };
      tiles-demo = style:
        (pkgs.callPackage ./demo.nix {}) {
          bundle = self'.buildTilesBundle {
            metadataFn = metadataFnFn {};
            host = "http://127.0.0.1:8081";
            styleFn = style;
          };
        };
      tiles-nginx-bundle = style:
        self'.buildTilesBundle {
          metadataFn = metadataFnFn {settings.compress = "gzip";};
          host = "http://127.0.0.1:8080";
          styleFn = style;
        };
      vm-builder = bundle:
        (
          nixpkgs.lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
              (import ./demo-nginx.nix {inherit bundle;})
            ];
          }
        )
        .config
        .system
        .build
        .vm;
    in {
      packages = {
        inherit (self') build_pbf_glyphs;
      };
      legacyPackages = {
        # styles = lib.mapAttrs () pkgs.tilesStyles
        inherit (pkgs) tilesStyles;
      } // self';
      apps = builtins.foldl' (left: right: left // right) {} (map (
          key: {
            "demo-local-${key}" = {
              type = "app";
              program = "${tiles-demo self'.tilesStyles.${key}}/bin/demo";
            };
            "demo-nginx-${key}" = {
              type = "app";
              program = "${vm-builder (tiles-nginx-bundle self'.tilesStyles.${key})}/bin/run-nixos-vm";
            };
          }
        ) [
          "maptiler-basic-gl-style"
          "osm-bright-gl-style"
          "positron-gl-style"
          "dark-matter-gl-style"
          "maptiler-terrain-gl-style"
          "maptiler-3d-gl-style"
          "fiord-color-gl-style"
          "maptiler-toner-gl-style"
          "osm-liberty"
        ]);
    };
  in (utils.lib.eachDefaultSystem buildForSystem);
}
