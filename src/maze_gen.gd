extends TileMapLayer
class_name Maze

static var level: int = 1

var x_dim: int = level_to_dim(level)
var y_dim: int = x_dim

static func level_to_dim(lev: int) -> int:
	return ((lev % 2) + 1) + lev

func _can_move_to(current: Vector2i) -> bool:
	var _MAZE_RECT: Rect2i = Rect2i(Vector2i.ZERO, Vector2i(x_dim, y_dim))
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
	
	($/root/Main/Target as Node2D).position = Vector2i(30, 30) * (Vector2i(x_dim, y_dim) - Vector2i.ONE) + Vector2i(15, 15)
	
	($/root/Main/Arrows as CanvasItem).set_visible(level == 1)
	if (level == 1):
		return
	
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
				if new_pos % 2 == Vector2i.ONE and randi_range(1, randi_range(2, 5)) == 1:
					set_cell(new_pos, 0, Vector2i.ZERO)
				else:
					found_new_path = true
					fringe.append(new_pos)
		# if we hit a dead end or are at a cross section
		if !found_new_path:
			set_cell(current, 0, Vector2i.ZERO)
