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
	"share/maps/map-gl-styles"  = styles;
	"share/maps/sprites" = sprites;
	"share/sdf-fonts" = fonts;
}
