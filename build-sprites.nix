{ lib
, runCommand
, map-sprite-packer
, optipng ? null
}:

{ name
# A List of SVG Source folders
, srcs
, config ? { width = 600; height = 800; }
, optimize ? true
, path ? ""
}:

assert optimize -> optipng != null;

runCommand name {
	buildInputs = [map-sprite-packer optipng];
} (let
		folder = "$out" + path;
	in lib.concatLines ([
		"mkdir -p ${folder}"

		"map-sprite-packer \\"
			"${
				lib.concatStringsSep " "
					(map
						(dir: "--svgs ${dir}")
						srcs
					)
			} \\"
			"--width ${toString config.width} \\"
			"--height ${toString config.height} \\"
			"--output ${folder}"

	] ++ lib.optionals optimize [
		"optipng -o9 ${folder}/sprite.png"
		"optipng -o9 ${folder}/sprite@2x.png"
	]))
