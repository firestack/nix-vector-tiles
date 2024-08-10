{ linkFarm
, buildTiles
# , buildFonts
# , buildSt
}:

{ name
, sources
# , font-glyphs
, fonts
, styles
}: let
	root = "share/maps/vector";
in linkFarm name {
	"${root}/sources"   = sources;
	"${root}/styles"    = styles;
	# "${root}/fonts"   = font-glyphs;
	"${root}/sdf/fonts" = fonts;
}
