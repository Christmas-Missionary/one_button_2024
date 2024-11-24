extends CharacterBody2D
class_name Bullet

func as_child_to(parent: Node) -> Bullet:
	parent.add_child(self)
	return self

func spawn(player_pos: Vector2, rot: float) -> void:
	var _direction: Vector2 = Vector2.DOWN.rotated(rot)
	velocity = _direction * 480.0
	position = player_pos + _direction * 25.0

func _physics_process(_delta) -> void:
	move_and_slide()
	if is_on_wall():
		match (get_wall_normal()):
			Vector2.UP, Vector2.DOWN:
				velocity.y = -velocity.y
			Vector2.LEFT, Vector2.RIGHT:
				velocity.x = -velocity.x
			_:
				velocity = velocity * (Vector2(-1, 1) if randi() % 2 else Vector2(1, -1))
