extends Spatial

export var width = 100
export var height = 100
export var number_of_tiles = 50

var tile_scene = load("res://Tile.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	generate_tiles()

func generate_tiles():
	for n in range(0, number_of_tiles):
		var pos = Vector3(rng.randi_range(-width/2, width/2), rng.randi_range(0, height), 0)
		
		if not is_close_to_some_tile(pos):
			var tile = tile_scene.instance()
			tile.translation = pos
			tile.has_tree = Global.randb()
			tile.has_grass = Global.randb()
			add_child(tile)

func is_close_to_some_tile(pos):
	for tile in get_tree().get_nodes_in_group("Tile"):
		if tile.translation.distance_to(pos) < 5:
			return true
	
	return false
