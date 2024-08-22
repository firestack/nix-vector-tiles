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
}: linkFarm name {
	"share/maps/vector/sources" = sources;
	"share/maps/styles/maplibre-gl-style" = styles;
	"share/maps/sprites" = sprites;
	"share/sdf-fonts" = fonts;
}
