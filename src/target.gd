extends Area2D

signal bullet_entered

func _physics_process(delta: float) -> void:
	const _ROT_SPEED: float = PI / 1.2
	rotate(_ROT_SPEED * delta)

func next_level(body: Node2D) -> void:
	if body is Bullet:
		bullet_entered.emit()
		get_tree().set_pause(true)
