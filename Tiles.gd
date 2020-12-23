extends Spatial

var tile_scene = load("res://Tile.tscn")

func build(map):
	for x in range(0,map.size()):
		for z in range(0, map[x].size()):
			add_tile_at(x, z, map[x][z])

func add_tile_at(x, z, type):
	var tile = tile_scene.instance()
	tile.translation = Vector3(x*5, 0, z*5)
	if "G" in type:
		tile.has_grass = true
	if "T" in type:
		tile.has_tree = true
	if type == "W":
		pass
	
	add_child(tile)
