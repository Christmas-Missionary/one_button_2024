extends TileMapLayer
class_name MazeGen
const y_dim: int = 17
const x_dim: int = 17

var allow_loops: bool = false

var adj4 = [
	Vector2i(-1, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(0, -1),
]

func _can_move_to(current: Vector2i) -> bool:
	const _MAZE_RECT: Rect2i = Rect2i(Vector2i.ZERO, Vector2i(x_dim, y_dim))
	return _MAZE_RECT.has_point(current) and get_cell_atlas_coords(current) != Vector2i.ZERO

func _ready() -> void:
	# place_border
	for y in range(-1, y_dim):
		set_cell(Vector2(-1, y), 0, Vector2i.ZERO)
	for x in range(-1, x_dim):
		set_cell(Vector2(x, -1), 0, Vector2i.ZERO)
	for y in range(-1, y_dim + 1):
		set_cell(Vector2(x_dim, y), 0, Vector2i.ZERO)
	for x in range(-1, x_dim + 1):
		set_cell(Vector2(x, y_dim), 0, Vector2i.ZERO)
	
	# Generate inside of maze
	var fringe: Array[Vector2i] = [Vector2i.ZERO]
	var seen = {}
	while fringe.size() > 0:
		var current: Vector2i 
		current = fringe.pop_back() as Vector2
		if current in seen or not _can_move_to(current):
			continue
		seen[current] = true
		if current.x % 2 == 1 and current.y % 2 == 1:
			set_cell(current, 0, Vector2i.ZERO)
			continue
		var found_new_path = false
		adj4.shuffle()
		for pos in adj4:
			var new_pos = current + pos
			if new_pos not in seen and _can_move_to(new_pos):
				var chance_of_no_loop = randi_range(1, 1)
				if allow_loops:
					chance_of_no_loop = randi_range(1, 5)
				if (new_pos.x % 2 == 1 and new_pos.y % 2 == 1) and chance_of_no_loop == 1:
					set_cell(new_pos, 0, Vector2i.ZERO)
				else:
					found_new_path = true
					fringe.append(new_pos)
		#if we hit a dead end or are at a cross section
		if not found_new_path:
			set_cell(current, 0, Vector2i.ZERO)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Reset"):
		get_tree().reload_current_scene()
