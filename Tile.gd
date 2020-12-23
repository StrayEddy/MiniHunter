extends Spatial

export var has_tree = false
export var has_grass = false

var tree_scene = load("res://Tree.tscn")
var multigrass_scene = load("res://MultiGrass.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if has_tree:
		build_trees()
	if has_grass:
		build_grass()

func build_trees():
	var tree = tree_scene.instance()
	tree.rotate_y(randi()%180)
	add_child(tree)

func build_grass():
	var multigrass = multigrass_scene.instance()
	add_child(multigrass)
