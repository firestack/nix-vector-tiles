{
  description = "A rust project";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
    map-sprite-packer = {
      url = "github:jmpunkt/map-sprite-packer";
      inputs.nixpkgs.follows = "/nixpkgs";
      inputs.utils.follows = "utils";
    };
  };
  outputs = {
    self,
    nixpkgs,
    utils,
    map-sprite-packer,
  }: let
    buildForSystem = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      # overlays = [self.overlays.default];

      # pkgs = import nixpkgs {inherit system overlays;};

      # metadataFnFn = config: tilesUrl:
      #   pkgs.buildTilesMetadata {
      #     tileJson = {tiles = [tilesUrl];};
      #     tiles = pkgs.buildTiles {
      #       inherit config;
      #       inherit (hessen) name;
      #       renumber = true;
      #       src = pkgs.fetchGeofabrik massachusetts;
      #     };
      #   };

      # tiles-demo = style:
      #   (pkgs.callPackage ./demo.nix {}) {
      #     bundle = pkgs.buildTilesBundle {
      #       metadataFn = metadataFnFn {};
      #       host = "http://127.0.0.1:8081";
      #       styleFn = style;
      #     };
      #   };

      # tiles-nginx-bundle = style:
      #   pkgs.buildTilesBundle {
      #     metadataFn = metadataFnFn {settings.compress = "gzip";};
      #     host = "http://127.0.0.1:8080";
      #     styleFn = style;
      #   };

      # vm-builder = bundle:
      #   (
      #     nixpkgs.lib.nixosSystem
      #     {
      #       system = "x86_64-linux";
      #       modules = [
      #         {nixpkgs.overlays = overlays;}
      #         "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
      #         (import ./demo-nginx.nix {inherit bundle;})
      #       ];
      #     }
      #   )
      #   .config
      #   .system
      #   .build
      #   .vm;
    in {
      legacyPackages = {
        scope = pkgs.callPackage ./scope.nix {
          makeScope = pkgs.lib.makeScope;
        };

        inherit (pkgs) tilesStyles;
      };

      # packages = {
      #   inherit (pkgs) build_pbf_glyphs;
      # };
      # apps = builtins.foldl' (left: right: left // right) {} (map (
      #     key: {
      #       "demo-${key}" = {
      #         type = "app";
      #         program = "${tiles-demo pkgs.tilesStyles.${key}}/bin/demo";
      #       };
      #       "demo-nginx-${key}" = {
      #         type = "app";
      #         program = "${vm-builder (tiles-nginx-bundle pkgs.tilesStyles.${key})}/bin/run-nixos-vm";
      #       };
      #     }
      #   ) [
      #     "maptiler-basic-gl-style"
      #     "osm-bright-gl-style"
      #     "positron-gl-style"
      #     "dark-matter-gl-style"
      #     "maptiler-terrain-gl-style"
      #     "maptiler-3d-gl-style"
      #     "fiord-color-gl-style"
      #     "maptiler-toner-gl-style"
      #     "osm-liberty"
      #   ]);
    };
  in
    (utils.lib.eachDefaultSystem buildForSystem)
    // {
      overlays = {
        default = nixpkgs.lib.composeManyExtensions [
          map-sprite-packer.overlays.default
          # self.overlays.packages
        ];
        # packages = final: prev: {
        #   build_pbf_glyphs = buildRustPkgs prev;
        #   fetchGeofabrik = prev.callPackage ./fetch-geofabrik.nix {};
        #   buildTiles = prev.callPackage ./build-tiles.nix {};
        #   buildTilesBundle = prev.callPackage ./build-bundle.nix {};
        #   buildTilesFonts = prev.callPackage ./build-fonts.nix {};
        #   buildTilesStyle = prev.callPackage ./build-style.nix {};
        #   buildTilesMetadata = prev.callPackage ./build-metadata.nix {};
        #   tilesStyles = final.callPackage ./styles.nix {};
        # };
      };
    };
}
