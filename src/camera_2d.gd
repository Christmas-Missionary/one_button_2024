extends Camera2D

func _ready() -> void:
	adjust_camera()

func adjust_camera():
	const INIT_SIZE: Vector2 = Vector2(650, 650)
	var maze: = $/root/Main/TileMapLayer as Maze
	var tile_size: int = maze.tile_set.tile_size.x # tile_size.y must be the same
	var maze_size: Vector2 = Vector2(maze.x_dim + 2, maze.y_dim + 2) * tile_size
	zoom = INIT_SIZE / maze_size
	var center_cell: Vector2i = Vector2i(maze.x_dim, maze.y_dim) / 2
	#center_cell.y -= 1
	global_position = maze.to_global(maze.map_to_local(center_cell))

func _process(delta: float) -> void:
	adjust_camera()
