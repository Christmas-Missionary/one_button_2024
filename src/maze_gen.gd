extends TileMapLayer
class_name MazeGen
const normal_wall_atlas_coords = Vector2i.ZERO
const SOURCE_ID = 0
const y_dim = 17
const x_dim = 17

var starting_pos = Vector2i()
var allow_loops: bool = false
var spot_to_letter = {}
var spot_to_label = {}
var current_letter_num = 65

@export var starting_coords = Vector2i(0, 0)
var adj4 = [
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
]

func _ready() -> void:
	place_border()
	dfs(starting_coords)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Reset"):
		get_tree().reload_current_scene()

func place_border():
	for y in range(-1, y_dim):
		place_wall(Vector2(-1, y))
	for x in range(-1, x_dim):
		place_wall(Vector2(x, -1))
	for y in range(-1, y_dim + 1):
		place_wall(Vector2(x_dim, y))
	for x in range(-1, x_dim + 1):
		place_wall(Vector2(x, y_dim))

func delete_cell_at(pos: Vector2):
	set_cell(pos, -1)

func place_wall(pos: Vector2):
	set_cell(pos, SOURCE_ID, normal_wall_atlas_coords)

func will_be_converted_to_wall(spot: Vector2i):
	return (spot.x % 2 == 1 and spot.y % 2 == 1)

func is_wall(pos):
	return get_cell_atlas_coords(pos) in [
		normal_wall_atlas_coords
	]

func can_move_to(current: Vector2i):
	return (
			current.x >= 0 and current.y >= 0 and\
			current.x < x_dim and current.y < y_dim and\
			not is_wall(current)
	)

func dfs(start: Vector2i):
	var fringe: Array[Vector2i] = [start]
	var seen = {}
	while fringe.size() > 0:
		var current: Vector2i 
		current = fringe.pop_back() as Vector2
		if current in seen or not can_move_to(current):
			continue
			
		seen[current] = true
		if current in spot_to_label:
			for node in spot_to_label[current]:
				node.queue_free()
##			var existing_letter = find_child(spot_to_letter[current])
#			if existing_letter != null:
#				existing_letter.queue_free()
		if current.x % 2 == 1 and current.y % 2 == 1:
			place_wall(current)
			continue
			
		#set_cell(current, SOURCE_ID, walkable_atlas_coords)
		
		
		var found_new_path = false
		adj4.shuffle()
		for pos in adj4:
			var new_pos = current + pos
			if new_pos not in seen and can_move_to(new_pos):
				var chance_of_no_loop = randi_range(1, 1)
				if allow_loops:
					chance_of_no_loop = randi_range(1, 5)
				if will_be_converted_to_wall(new_pos) and chance_of_no_loop == 1:
					place_wall(new_pos)
				else:
					found_new_path = true
					fringe.append(new_pos)
		#if we hit a dead end or are at a cross section
		if not found_new_path:
			place_wall(current)
