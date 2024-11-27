extends Timer

func _ready() -> void:
	start(randf_range(0.05, 2.0))

func change_scene() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(preload("res://src/main.tscn"))
