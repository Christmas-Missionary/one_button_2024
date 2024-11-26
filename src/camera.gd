extends Camera2D

# tile_size.x and tile_size.y must be the same
func _ready() -> void:
	var maze: = $/root/Main/Maze as Maze 
	zoom = Vector2(650, 650) / (Vector2(maze.x_dim + 2, maze.y_dim + 2) * maze.tile_set.tile_size.x)
	global_position = maze.to_global(maze.map_to_local(Vector2i(maze.x_dim, maze.y_dim) / 2))
