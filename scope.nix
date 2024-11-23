{ makeScope
, newScope
}:
makeScope newScope (self: {
	build_pbf_glyphs = self.callPackage ./packages/build-pbf-glyphs {};
	map-sprite-packer = self.callPackage ./packages/map-sprite-packer {};

	fetchGeofabrik = self.callPackage ./fetch-geofabrik.nix {};
	buildTiles = self.callPackage ./build-tiles.nix {};
	buildTilesBundle = self.callPackage ./build-bundle.nix {};
	buildTilesFonts = self.callPackage ./build-fonts.nix {};
	buildTilesStyle = self.callPackage ./build-style.nix {};
	buildTilesMetadata = self.callPackage ./build-metadata.nix {};
	tilesStyles = self.callPackage ./styles.nix {};


	# GeoFabrik Exports
	germany = self.fetchGeofabrik {
		name = "germany";
		continent = "europe";
		date = "230101";
		sha256 = "sha256-G/9YWx4uEY6/yGVr2O5XqL6ivrlpX8Vs6xMlU2nT1DE=";
	};

	hessen = self.fetchGeofabrik {
		name = "hessen";
		continent = "europe";
		country = "germany";
		date = "230101";
		sha256 = "sha256-sOoPtIEY4TxSm/p0MGc9LGzQtQmIafGH0IWbkby95K8=";
	};

	massachusetts = self.fetchGeofabrik {
		name = "massachusetts";
		continent = "north-america";
		country = "us";
		date = "240101";
		sha256 = "sha256-qy2uQnHf8leLPaf3tvu8Pp5UiOapSaUfBXtcu8Kgz4o=";
	};

	buildDemo = self.callPackage ./demo.nix {};
})
