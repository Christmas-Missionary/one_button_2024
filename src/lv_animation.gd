extends ColorRect

@onready var _anime: = $Animation as AnimationPlayer
@onready var _audio: = $Audio as AudioStreamPlayer
@onready var _maze: = $"../Maze" as Maze

func _play() -> void:
	_anime.play(&"Fade")
	_audio.play()

# Called by _anime just before finishing
func _transition() -> void:
	get_tree().set_pause(false)
	_maze.level += 1
