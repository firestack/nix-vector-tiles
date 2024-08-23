{ lib
, runCommand
, python3
, fontconfig
}:
{ name ? "fonts-dir"
, fonts-dir
, wanted-fonts
}: runCommand name {
	buildInputs = [python3 fontconfig];
} (lib.concatLines [
	"mkdir $out"
	"python3 \\"
	"	${./packages/link-fonts/link-fonts.py} \\"
	"	${wanted-fonts} \\"
	"	<(fc-scan \\"
	"		--format '%{file}:%{fullname}\n' \\"
	"		${fonts-dir}"
	"	) \\"
	"	$out"
])

