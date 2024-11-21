{ makeScope
, newScope
}:
makeScope newScope (self: {
	build_pbf_glyphs = self.callPackage ./packages/build-pbf-glyphs {};

	fetchGeofabrik = self.callPackage ./fetch-geofabrik.nix {};
	buildTiles = self.callPackage ./build-tiles.nix {};
	buildTilesBundle = self.callPackage ./build-bundle.nix {};
	buildTilesFonts = self.callPackage ./build-fonts.nix {};
	buildTilesStyle = self.callPackage ./build-style.nix {};
	buildTilesMetadata = self.callPackage ./build-metadata.nix {};
	tilesStyles = self.callPackage ./styles.nix {};
})
