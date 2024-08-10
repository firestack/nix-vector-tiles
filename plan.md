
```mermaidjs
graph TB
	OSM 
	--> fetchGeofabrik
	-. ? .-> osmium-renumber & TileMaker

	osmium-renumber
	--> TileMaker

	config & tilemaker-openmaptiles-config
	--> tilemaker-config

	subgraph build_tiles

	ShapeFiles
	--> TileMaker
		tilemaker-config
		--> TileMaker
		--> output


		subgraph output
			PMTiles & MBTiles & XYZ?
		end
	end

	output
	--> buildTileserverShare
	subgraph fonts
		direction TB

		buildFonts
		--> build-pbf-glyphs
	end

	subgraph styles
		icons
		mapbox_style_gl
	end

	icons --> sprites
	styles -.-> sprites

	styles -....-> fonts

	noto & roboto & others
	--> buildFonts
	note1[[Not Finished]] -.-> fonts
	styles & sprites
	--------> buildTileserverShare
	fonts
	--> buildTileserverShare
	--> TileServer-gl
	--> TileJSON & Styles & VectorData & Sprites & Fonts & Icons & RasterData

	buildTileserverShare
	-.-> TileServer-config
	--> TileServer-gl

```
