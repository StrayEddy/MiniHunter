extends Spatial

export var nb_of_trees = 500
export var nb_of_multigrasses = 2000

var tree_scene = load("res://Tree.tscn")
var multigrass_scene = load("res://MultiGrass.tscn")

var size = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	build_terrain()

func build_terrain():
	add_trees()
	add_multigrasses()

func add_trees():
	for i in range(0, nb_of_trees):
		var tree = tree_scene.instance()
		var rand_x = rand_range(-size/2, size/2)
		var rand_z = rand_range(-size/2, size/2)
		tree.translate(Vector3(rand_x, 0, rand_z))
		$Trees.add_child(tree)

func add_multigrasses():
	for i in range(0, nb_of_multigrasses):
		var multigrass = multigrass_scene.instance()
		var rand_x = rand_range(-size/2, size/2)
		var rand_z = rand_range(-size/2, size/2)
		multigrass.translate(Vector3(rand_x, 0, rand_z))
		$Grasses.add_child(multigrass)
