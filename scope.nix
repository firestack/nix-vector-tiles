{ makeScope
, newScope
}:
makeScope newScope (self: {

	build_pbf_glyphs = self.callPackage ./packages/build-pbf-glyphs {};

	buildTilesFonts = self.callPackage ./build-fonts.nix {};
	buildTilesStyle = self.callPackage ./build-style.nix {};

	buildTiles = self.callPackage ./build-tiles.nix {};
	buildTilesBundle = self.callPackage ./build-bundle.nix {};
	buildTilesMetadata = self.callPackage ./build-metadata.nix {};

	tilesStyles = self.callPackage ./styles.nix {};

	noto-tiles = self.callPackage ({ buildTilesFonts, noto-fonts }: buildTilesFonts {
		name = "noto";
		fonts = [noto-fonts];
	}) {};

	roboto-tiles = self.callPackage ({ buildTilesFonts, roboto }:
		(buildTilesFonts {
			name = "roboto";
			fonts = [roboto];
		})
		.overrideAttrs (old: {
			installPhase =
				(old.installPhase or "")
				+ ''
				 mv $out/share/map-fonts/Roboto "$out/share/map-fonts/Roboto Regular"
				'';
		})) {};

	fetchGeofabrik = self.callPackage ./fetch-geofabrik.nix {};
	osm.germany = self.fetchGeofabrik {
		name = "germany";
		continent = "europe";
		date = "230101";
		sha256 = "sha256-G/9YWx4uEY6/yGVr2O5XqL6ivrlpX8Vs6xMlU2nT1DE=";
	};

	osm.hessen = self.fetchGeofabrik {
		name = "hessen";
		continent = "europe";
		country = "germany";
		date = "230101";
		sha256 = "sha256-sOoPtIEY4TxSm/p0MGc9LGzQtQmIafGH0IWbkby95K8=";
	};

	osm.massachusetts = self.fetchGeofabrik {
		name = "massachusetts";
		continent = "north-america";
		country = "us";
		date = "240729";
		sha256 = "sha256-CwxG44skIq1+q1GTF9P520xYalIojU/bywvT85Ye644=";
	};

	bundles.dark-matter-gl-style = self.buildTilesBundle {
		host = "http://127.0.0.1:8081";
		styleFn = self.tilesStyles.dark-matter-gl-style;
		metadataFn = tilesUrl: self.buildTilesMetadata {
			tileJson = {tiles = [tilesUrl];};
			tiles = self.buildTiles {
				# inherit config;
				# inherit (hessen) name;
				renumber = true;
				src = self.osm.massachusetts;
				name = self.osm.massachusetts.name;
			};
		};
 };
})
