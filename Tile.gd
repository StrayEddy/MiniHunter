extends Spatial

export(String, "S", "M", "L") var size = ""
export var has_tree = false
export var has_grass = false

var tree_scene = load("res://Tree.tscn")
var grass_scene = load("res://Grass.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if size == "":
		var sizes = ["S", "M", "L"]
		sizes.shuffle()
		size = sizes[0]
	
	match size:
		"S":
			$Small.visible = true
			$Medium.queue_free()
			$Large.queue_free()
		"M":
			$Small.queue_free()
			$Medium.visible = true
			$Large.queue_free()
		"L":
			$Small.queue_free()
			$Medium.queue_free()
			$Large.visible = true
	
	if has_tree:
		build_trees()
	if has_grass:
		build_grass()

func build_trees():
	match size:
		"S":
			var tree = tree_scene.instance()
			tree.rotate_y(randi()%180)
			add_child(tree)
		"M":
			var tree1 = tree_scene.instance()
			var tree2 = tree_scene.instance()
			tree1.translate(Vector3(1,0,0))
			tree2.translate(Vector3(-1,0,0))
			tree1.rotate_y(randi()%180)
			tree2.rotate_y(randi()%180)
			add_child(tree1)
			add_child(tree2)
		"L":
			var tree1 = tree_scene.instance()
			var tree2 = tree_scene.instance()
			var tree3 = tree_scene.instance()
			tree1.translate(Vector3(2.5,0,0))
			tree2.translate(Vector3(0,0,0))
			tree3.translate(Vector3(-2.5,0,0))
			tree1.rotate_y(randi()%180)
			tree2.rotate_y(randi()%180)
			tree3.rotate_y(randi()%180)
			add_child(tree1)
			add_child(tree2)
			add_child(tree3)

func build_grass():
	match size:
		"S":
			var grass = grass_scene.instance()
			grass.rotate_y(randi()%180)
			add_child(grass)
		"M":
			var grass1 = grass_scene.instance()
			var grass2 = grass_scene.instance()
			grass1.translate(Vector3(1,0,0))
			grass2.translate(Vector3(-1,0,0))
			grass1.rotate_y(randi()%180)
			grass2.rotate_y(randi()%180)
			add_child(grass1)
			add_child(grass2)
		"L":
			var grass1 = grass_scene.instance()
			var grass2 = grass_scene.instance()
			var grass3 = grass_scene.instance()
			grass1.translate(Vector3(2.5,0,0))
			grass2.translate(Vector3(0,0,0))
			grass3.translate(Vector3(-2.5,0,0))
			grass1.rotate_y(randi()%180)
			grass2.rotate_y(randi()%180)
			grass3.rotate_y(randi()%180)
			add_child(grass1)
			add_child(grass2)
			add_child(grass3)
