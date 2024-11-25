extends ColorRect

func _play() -> void:
	($Animation as AnimationPlayer).play(&"Fade")
	var _audio: = $Audio as AudioStreamPlayer
	_audio.play()
	await _audio.finished
	Maze.level += 1
	get_tree().set_pause(false)
	get_tree().reload_current_scene()
