{ lib
, runCommand
, jq
}:
{ styles
, name ? "used-styles.json"
}:
runCommand name
{
	buildInputs = [jq];
	meta.description =
		"Queries a map(libre|box)-gl-style files for the fonts"
		+ " that are used";
}
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
	# TODO: convert this to a argument?
	"${styles}/share/map/styles/*/style.json \\"
	"> $out"
])

