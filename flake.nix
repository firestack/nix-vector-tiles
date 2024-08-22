{
  description = "A rust project";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
    # map-sprite-packer = {
    #   url = "github:jmpunkt/map-sprite-packer";
    #   inputs.nixpkgs.follows = "/nixpkgs";
    #   inputs.utils.follows = "utils";
    # };
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }: let
    buildForSystem = system: let
      pkgs = nixpkgs.legacyPackages.${system};

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

    in {
        legacyPackages = let
          scope = pkgs.callPackage ./scope.nix {
            makeScope = pkgs.lib.makeScope;
          };
        in  {
          outputs = scope;
        } // scope;

        checks = {
          inherit
            (self.legacyPackages.${system})
            mapbox-gl-styles-fhs-fonts-used
            tileset;
        };
      };
    in
    (utils.lib.eachDefaultSystem buildForSystem);
}
