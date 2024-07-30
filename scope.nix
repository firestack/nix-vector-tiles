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

	buildDemo = self.callPackage ./demo.nix {};
})
