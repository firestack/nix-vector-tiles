{ fetchFromGitHub
, rustPlatform
, protobuf
, freetype
}:
rustPlatform.buildRustPackage {
	pname = "build_pbf_glyphs";
	version = "1.4.1";

	patches = [./pbf_font_tools-Protoc.patch];

	src = fetchFromGitHub {
		owner = "stadiamaps";
		repo = "sdf_font_tools";
		rev = "cli-v1.4.1";
		sha256 = "sha256-8xH9TpaC1KaaBFY5fsq3XZrNM44ZNxzs5W+Zg3aGkJU=";
	};
	cargoBuildFlags = "-p build_pbf_glyphs";

	cargoSha256 = "sha256-m+ysA7fJqytFbSdPPNl6TQj6QAft13bO89LboTwb0uU=";

	nativeBuildInputs = [
		protobuf
	];

	buildInputs = [
		freetype
	];

	meta.mainProgram = "build_pbf_glyphs";
}

