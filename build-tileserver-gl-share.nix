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
	"share/map/vector/sources" = sources;
	"share/map/styles/maplibre-gl-style" = styles;
	"share/map/sprites" = sprites;
	"share/map/sdf-fonts" = fonts;
}
