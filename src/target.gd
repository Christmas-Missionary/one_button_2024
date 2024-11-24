extends Area2D

func _physics_process(delta: float) -> void:
	const _ROT_SPEED: float = PI / 1.2
	rotate(_ROT_SPEED * delta)

func next_level(_body) -> void:
	print("Bullet has hit target.")
