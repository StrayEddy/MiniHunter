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
	var noise = OpenSimplexNoise.new()
	noise.seed = Global.rng.randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 1.0
	
	var min_n = 0
	var max_n = 0
	
	var nb_multigrass = 0
	var nb_tree = 0
	for x in range(0, 500, 10):
		for z in range(0, 500, 10):
			var value = noise.get_noise_2d(float(x), float(z))
			if value < min_n:
				min_n = value
			elif value > max_n:
				max_n = value

			if value > 0:
				add_multigrass(x-250 + randf()*10, z-250 + randf()*10)
				nb_multigrass += 1
				if value > 0.4:
					add_tree(x-250 + randf()*10, z-250 + randf()*10)
					nb_tree += 1

	print(nb_multigrass)
	print(nb_tree)

func add_multigrass(x,z):
	var multigrass = multigrass_scene.instance()
	multigrass.translate(Vector3(x, 0, z))
	multigrass.rotate_y(Global.randrad())
	$Grasses.add_child(multigrass)

func add_tree(x,z):
	var tree = tree_scene.instance()
	tree.translate(Vector3(x, 0, z))
	tree.rotate_y(Global.randrad())
	$Trees.add_child(tree)
