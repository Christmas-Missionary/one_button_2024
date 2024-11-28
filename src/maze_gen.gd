extends TileMapLayer
class_name Maze

var maze_length: int
@onready var level: int:
	set(val):
		level = val
		maze_length = level_to_size(val)
		level_changed.emit(val)

@onready var _target: = $"../Target" as Node2D
@onready var _arrows: = $"../Arrows" as CanvasItem

signal level_changed(val: int)

static func level_to_size(lev: int) -> int:
	return ((lev % 2) + 1) + lev

func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	if ResourceLoader.exists(_SAVE_PATH) and ResourceLoader.load(_SAVE_PATH) != null:
		var save_game: = ResourceLoader.load(_SAVE_PATH) as SaveGame
		if save_game != null and !save_game.are_cells_null():
			level = save_game.level
			level_changed.connect(_generate_maze)
			for cell: Vector2i in save_game.get_cells():
				set_cell(cell, 0, Vector2i.ZERO)
			_target.position = Vector2i(30, 30) * (Vector2i.ONE * (maze_length - 1)) + Vector2i(15, 15)
			return
	level_changed.connect(_generate_maze)
	level = 1

func _can_move_to(current: Vector2i) -> bool:
	var _MAZE_RECT: Rect2i = Rect2i(Vector2i.ZERO, Vector2i.ONE * maze_length)
	return _MAZE_RECT.has_point(current) and get_cell_atlas_coords(current) != Vector2i.ZERO

func _generate_maze(level_val: int) -> void:
	clear()
	# place_border
	for y in range(-1, maze_length):
		set_cell(Vector2i(-1, y), 0, Vector2i.ZERO)
	for x in range(-1, maze_length):
		set_cell(Vector2i(x, -1), 0, Vector2i.ZERO)
	for y in range(-1, maze_length + 1):
		set_cell(Vector2i(maze_length, y), 0, Vector2i.ZERO)
	for x in range(-1, maze_length + 1):
		set_cell(Vector2i(x, maze_length), 0, Vector2i.ZERO)
	
	_target.position = Vector2i(30, 30) * (Vector2i.ONE * (maze_length - 1)) + Vector2i(15, 15)
	
	_arrows.set_visible(level_val == 1)
	if (level_val == 1):
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
	
	if Touch.is_mobile_on_web:
		_is_new_level = false
		(SaveGame.new()
				 .save(level, get_used_cells())
				 .to(_SAVE_PATH))
	else:
		_is_new_level = true

## The last five characters lower chances of this save file colliding with other games.
const _SAVE_PATH: String = "user://one_button_2024_n80x3.tres"

var _is_new_level: bool = false

func _notification(arg: int) -> void:
	if (arg == NOTIFICATION_WM_MOUSE_EXIT or arg == NOTIFICATION_WM_CLOSE_REQUEST) and _is_new_level:
		_is_new_level = false
		(SaveGame.new()
				 .save(level, get_used_cells())
				 .to(_SAVE_PATH))
	if arg == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func wipe_save() -> void:
	ResourceSaver.save(Resource.new(), _SAVE_PATH)
