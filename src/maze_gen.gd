extends TileMapLayer

const _Y_DIM: int = 17
const _X_DIM: int = 17

var _allow_loops: bool = false

func _can_move_to(current: Vector2i) -> bool:
	const _MAZE_RECT: Rect2i = Rect2i(Vector2i.ZERO, Vector2i(_X_DIM, _Y_DIM))
	return _MAZE_RECT.has_point(current) and get_cell_atlas_coords(current) != Vector2i.ZERO

func _ready() -> void:
	# place_border
	for y in range(-1, _Y_DIM):
		set_cell(Vector2i(-1, y), 0, Vector2i.ZERO)
	for x in range(-1, _X_DIM):
		set_cell(Vector2i(x, -1), 0, Vector2i.ZERO)
	for y in range(-1, _Y_DIM + 1):
		set_cell(Vector2i(_X_DIM, y), 0, Vector2i.ZERO)
	for x in range(-1, _X_DIM + 1):
		set_cell(Vector2i(x, _Y_DIM), 0, Vector2i.ZERO)
	
	# Generate inside of maze
	var fringe: Array[Vector2i] = [Vector2i.ZERO]
	var seen: Array[Vector2i] = []
	var four_dirs: Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
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
		four_dirs.shuffle()
		for pos: Vector2i in four_dirs:
			var new_pos: Vector2i = current + pos
			if !seen.has(new_pos) and _can_move_to(new_pos):
				if new_pos % 2 == Vector2i.ONE and randi_range(1, 5 if _allow_loops else 1) == 1:
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
