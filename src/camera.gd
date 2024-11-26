extends Camera2D

@onready var maze: = $"../Maze" as Maze 

# tile_size.x and tile_size.y must be the same
func _adjust(_level_val) -> void:
	zoom = Vector2(650, 650) / (Vector2.ONE * (maze.maze_length + 2) * maze.tile_set.tile_size.x)
	global_position = maze.to_global(maze.map_to_local((Vector2i.ONE * maze.maze_length) / 2))
