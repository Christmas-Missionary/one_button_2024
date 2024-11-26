extends ColorRect

@onready var _anime: = $Animation as AnimationPlayer
@onready var _audio: = $Audio as AudioStreamPlayer
@onready var _maze: = $"../Maze" as Maze
@onready var _bullet_pool: Node = $/root/Main/BulletPool

func _play() -> void:
	_anime.play(&"Fade")
	_audio.play()
	await _audio.finished
	_maze.level += 1
	get_tree().set_pause(false)
	for bullet: Node in _bullet_pool.get_children():
		bullet.queue_free()
