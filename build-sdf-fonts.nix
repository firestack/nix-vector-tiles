{ runCommand
, lib
, build-pbf-glyphs
}:
{ name ? "fonts-sdf"
, fonts-dir
}:
runCommand
	name
	{
		buildInputs = [build-pbf-glyphs];
	}
	(lib.concatLines [
		"mkdir $out"
		"set -x"
		"build_pbf_glyphs \\"
		"	${fonts-dir}/ \\"
		"	$out"
		"set +x"
	])
