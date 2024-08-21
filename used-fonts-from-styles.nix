{ lib
, runCommand
, jq
}:
{ styles
}:
runCommand "used-styles.json"
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

