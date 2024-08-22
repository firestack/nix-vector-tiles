{ linkFarm
, buildTiles
# , buildFonts
# , buildSt
}:

{ name
, sources
, fonts
, styles
, sprites
}: let
	root = "share/maps/vector";
in linkFarm name {
	"${root}/sources"   = sources;
	"${root}/styles"    = styles;
	"${root}/sdf/fonts" = fonts;
	"${root}/sprites"   = sprites;
}
