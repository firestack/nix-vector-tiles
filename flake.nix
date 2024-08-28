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
      legacyPackages' = self.legacyPackages.${system};
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
            (legacyPackages')
            mapbox-gl-styles-fhs-fonts-used
            tileset;
        };
      };
    in
    (utils.lib.eachDefaultSystem buildForSystem);
}
