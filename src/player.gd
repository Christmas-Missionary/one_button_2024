extends Area2D

func _physics_process(delta: float) -> void:
	const _ROT_SPEED: float = PI / 1.2
	rotate(_ROT_SPEED * delta)

func _unhandled_key_input(event: InputEvent) -> void:
	const _BULLET_SCENE: PackedScene = preload("res://src/bullet.tscn")
	if event.is_action_pressed(&"OneButton"):
		(_BULLET_SCENE.instantiate() as Bullet).as_child_to(get_parent()).spawn(position, rotation)
