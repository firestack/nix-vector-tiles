{ lib
, runCommand
, mbutil
}:
{ src
}: runCommand "${src.name}-tiles" {
	buildInputs = [ mbutil ];
} (lib.concatLines [
	"mb-util ${src} $out --image_format=pbf --scheme=xyz"
])
