{ linkFarm
, buildTiles
# , buildFonts
# , buildSt
}:

{ name
# Attrs of name -> sources
# Attrs needed to generate tilejson OR tileserver-gl config?
, sources
# Attrs of styles
# TODO: Mayyybe need a way to provide either overrides per json or for all json?...
# Attrs needed to generate tilejson OR tileserver-gl config?
, styles
# Array of font packages, fc-scan needs to read these
# Needed for the reduction before pbf glyph building
, fonts
# linkFarm?
, sprites
}: linkFarm name {
	"share/map/vector/sources" = sources;
	"share/map/styles/maplibre-gl-style" = styles;
	"share/map/sprites" = sprites;
	"share/map/sdf-fonts" = fonts;
	# "share/map/tilejson.json" = tilejson;
	# "share/map/tileserver-gl.config.json" = tileserver-gl-json;
}
