extends ColorRect

func _play() -> void:
	($Animation as AnimationPlayer).play(&"Fade")
	var _audio: = $Audio as AudioStreamPlayer
	_audio.play()
	await _audio.finished
	($"../Maze" as Maze).level += 1
	get_tree().set_pause(false)
	var _bullet_pool: Node = $/root/Main/BulletPool
	for bullet: Node in _bullet_pool.get_children():
		bullet.queue_free()
