{ runCommand
, lib
, build-sdf-glyphs
}:
{ name ? "fonts-sdf"
, fonts-dir
}:
runCommand
	name
	{
		buildInputs = [build-sdf-glyphs];
	}
	(lib.concatLines [
		"build-pbf-glyphs \\"
		"	${fonts-dir} \\"
		"	$out"
	])
