{ lib
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, pixman
, cairo
, pango
}:

buildNpmPackage rec {
	pname = "tileserver-gl";
	version = "4.12.0";

	src = fetchFromGitHub {
		owner = "maptiler";
		repo = pname;
		rev = "v${version}";
		hash = "sha256-Md0v0zeymnZMLk/hc9w6aeaGdpCb0SWeZG+2NKvnAS0=";
	};

	npmDepsHash = "sha256-cWtqdbB8Mpcju4AeP9yXJWEV+rtlj2wpVyB6kJ+lAV4=";

	nativeInputs = [
		pkg-config
	];

	buildInputs = [
		pixman
		cairo
		pango
	];

	# The prepack script runs the build script, which we'd rather do in the build phase.
	# npmPackFlags = [ "--ignore-scripts" ];

	# NODE_OPTIONS = "--openssl-legacy-provider";

	meta = {
		description = " Vector and raster maps with GL styles. Server side rendering by MapLibre GL Native. Map tile server for MapLibre GL JS, Android, iOS, Leaflet, OpenLayers, GIS via WMTS, etc. ";
		homepage = "https://github.com/maptiler/tileserver-gl";
	};
}
