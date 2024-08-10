{ lib
, makeScope
, newScope
}:
makeScope newScope (self: {
	build-pbf-glyphs = self.callPackage ./packages/build-pbf-glyphs {};

	map-sprite-packer = self.callPackage ./packages/map-sprite-packer {};
	# map-sprite-packer = self.callPackage (
	# 	{ src
	# 	, rustPlatform
	# 	}: rustPlatform.buildRustPackage
	# ) {
	# 	src = map-sprite-packer-src;
	# };
	mapbox-gl-styles = self.callPackage ./styles.nix {};
	mapbox-gl-styles-links = self.callPackage (
		{ buildTileserverShare
		, mapbox-gl-styles
		}: buildTileserverShare {
			name = "";
			styles = builtins.removeAttrs mapbox-gl-styles [ "override" "overrideDerivation" ];
		}) {};

	buildSpriteSheet = self.callPackage ./build-sprites.nix {};

	buildSpriteSheetFromStyleRepo = self.callPackage (
		{ buildSpriteSheet
		}:
		src: buildSpriteSheet {
			name = "${src.repo or ""}.sprites";
			srcs = map (dir: src + dir) (src.passthru.icons-dirs or []);
			optimize = false;
		}) {};

	# sprites = self.callPackage ({ buildSpriteSheetFromStyleRepo, mapbox-gl-styles}: buildSpriteSheetFromStyleRepo mapbox-gl-styles.osm-liberty) {};
	sprites = self.callPackage (
		{ linkFarm
		, lib
		, buildSpriteSheetFromStyleRepo
		, mapbox-gl-styles
		}: linkFarm "out"
			(builtins.mapAttrs
				(_: buildSpriteSheetFromStyleRepo)
				(lib.filterAttrs
					(_: value: (value.passthru.icons-dirs or null) != null )
					(builtins.removeAttrs
						mapbox-gl-styles
						[ "override" "overrideDerivation" ]
					)
				)
			)
		) {};

	mapbox-gl-styles-fhs = self.callPackage (
		{ lib
		,	symlinkJoin
		,	buildTilesStyle
		,	mapbox-gl-styles
		}: symlinkJoin {
			name = "mapbox-gl-styles-fhs";
			paths = lib.mapAttrsToList
				(name: value: buildTilesStyle {
					src = value;
					fonts = [];
					overrideJson = {
						sources.openmaptiles.url = "{v3}";
						# glyphs = "{glyphs}";
					};
					name = name;
				})
				(builtins.removeAttrs
					mapbox-gl-styles
					[ "override" "overrideDerivation" ]
				);
		}
	) {};

	# mapbox-gl-styles-package = lib.mapAttrs (name: style-src: ) self.mapbox-gl-styles;

	buildTilesFonts = self.callPackage ./build-fonts.nix {};
	buildTilesStyle = self.callPackage ./build-style.nix {};

	buildTileserverShare = self.callPackage ./build-tileserver-gl-share.nix {};

	buildTiles = self.callPackage ./build-tiles.nix {};
	buildTilesBundle = self.callPackage ./build-bundle.nix {};
	buildTilesMetadata = self.callPackage ./build-metadata.nix {};

	# noto-glyphs = self.callPackage ({ noto-fonts, build_pbf_glyphs, runCommand }:
	# 	runCommand "noto-glyphs" {} (lib.concatLines [
	# 		"${lib.getExe build_pbf_glyphs} ${noto-fonts}/share/fonts/noto $out/share/fonts/noto"
	# 	])) {};

	tileset = self.callPackage (
		{ buildTileserverShare
		, buildTiles
		, buildTilesFonts
		, linkFarm

		, mapbox-gl-styles-fhs
		, osm

		, noto-fonts
		, roboto
		}: buildTileserverShare {
			name = "tiles-test";

			sources = linkFarm "sources" {
				"mass.pmtiles" = buildTiles {
					renumber = true;
					src = osm.massachusetts;
					name = osm.massachusetts.name;
				};
			};

			fonts = linkFarm "font-glphs" {
				# noto = buildTilesFonts {
				# 	name = "noto";
				# 	fonts = [noto-fonts];
				# };
				#
				# roboto = buildTilesFonts {
				# 	name = "roboto";
				# 	fonts = [roboto];
				# };
			};

			styles = "${mapbox-gl-styles-fhs}/share/map/styles";
		}) {};


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

	tilesDir = self.callPackage ./make-xyz-tiles.nix {
		src = self.tiles;
	};

	usedFontsFromStyles = self.callPackage (
		{ lib
		, runCommand
		, jq
		}:
		{ styles
		}: runCommand "used-styles.json"
			{ buildInputs = [jq];}
			(lib.concatLines [
				"jq '"
				"	["
				"		inputs"
				"		| .layers[].layout.\"text-font\""
				"		| select(. != null)"
				"		| map("
				"			if type == \"array\""
				"				then .[1][1]"
				"			else ."
				"				end"
				"		)"
				"	]"
				"	| flatten(2)"
				"	| unique"
				"	' \\"
				"${styles}/share/map/styles/*/style.json \\"
				"> $out"
			])
	) {};

	mapbox-gl-styles-fhs-fonts-used = self.callPackage (
		{ usedFontsFromStyles
		, mapbox-gl-styles-fhs
		}: usedFontsFromStyles { styles = mapbox-gl-styles-fhs; }
		)
		{};

	tilemaker-shp-files = self.callPackage (
		{ lib
		, stdenvNoCC
		, fetchFromGitHub
		, curl
		, cacert
		, unzip
		}: stdenvNoCC.mkDerivation {
			name = "tilemaker-shp-files";

			src = fetchFromGitHub {
				owner = "systemed";
				repo = "tilemaker";
				rev = "eab08d189ad97ddf5db7d915bcabe42ad3dab6af";
				hash = "sha256-A4I2xwB7E+7iwaLt8NGoAVrPLSmu6l8wNURu9EUqyTk=";
			};

		 	outputHashAlgo = "sha256";
		 	outputHashMode = "recursive";
		 	outputHash = "sha256-uHbBbvPAwtG8UY6vQFesXyECkGQw6x0HwDGTstsSa8s=";

			buildInputs = [ curl unzip ];

			SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";
			buildPhase = lib.concatLines [
				"bash -x get-landcover.sh"
				"bash -x get-coastline.sh"

				"mkdir -p $out"
				"mv landcover $out"
				"mv coastline $out"
			];

			dontInstall = true;
		}
) {};
})
