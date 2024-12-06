extends Camera2D

@onready var maze: = $"../Maze" as Maze 

# tile_size.x and tile_size.y must be the same
## Adjusts to the newly generated maze
func _adjust() -> void:
	zoom = Vector2(650, 650) / (Vector2.ONE * (maze.maze_length + 2) * maze.tile_set.tile_size.x)
	global_position = maze.to_global(maze.map_to_local((Vector2i.ONE * maze.maze_length) / 2))
