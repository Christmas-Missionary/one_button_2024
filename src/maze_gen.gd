extends TileMapLayer
class_name MazeGen
const y_dim: int = 17
const x_dim: int = 17

var allow_loops: bool = false

var adj4: Array[Vector2i] = [
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
		set_cell(Vector2i(-1, y), 0, Vector2i.ZERO)
	for x in range(-1, x_dim):
		set_cell(Vector2i(x, -1), 0, Vector2i.ZERO)
	for y in range(-1, y_dim + 1):
		set_cell(Vector2i(x_dim, y), 0, Vector2i.ZERO)
	for x in range(-1, x_dim + 1):
		set_cell(Vector2i(x, y_dim), 0, Vector2i.ZERO)
	
	# Generate inside of maze
	var fringe: Array[Vector2i] = [Vector2i.ZERO]
	var seen: Array[Vector2i] = []
	while fringe.size() > 0:
		var current: Vector2i = fringe[-1]
		fringe.resize(fringe.size() - 1)
		if seen.has(current) or !_can_move_to(current):
			continue
		seen.push_back(current)
		if current % 2 == Vector2i.ONE: # current is never negative, truncated division is fine.
			set_cell(current, 0, Vector2i.ZERO)
			continue
		var found_new_path: bool = false
		adj4.shuffle()
		for pos: Vector2i in adj4:
			var new_pos: Vector2i = current + pos
			if !seen.has(new_pos) and _can_move_to(new_pos):
				if new_pos % 2 == Vector2i.ONE and randi_range(1, 5 if allow_loops else 1) == 1:
					set_cell(new_pos, 0, Vector2i.ZERO)
				else:
					found_new_path = true
					fringe.append(new_pos)
		# if we hit a dead end or are at a cross section
		if !found_new_path:
			set_cell(current, 0, Vector2i.ZERO)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"Reset"):
		get_tree().reload_current_scene()
