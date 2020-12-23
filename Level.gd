extends Spatial

# map: [x][z]
var map

func _ready():
	pass
#	build_level()

func build_level():
#	Get map
	map = read_csv()
#	Build tiles
	$Tiles.build(map)

func read_csv():
	var result = []
	var file = File.new()
	file.open("res://assets/CSVs/map.csv", file.READ)
	while !file.eof_reached():
		var line = file.get_csv_line()
		result.append(line)
	file.close()
	return result

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
