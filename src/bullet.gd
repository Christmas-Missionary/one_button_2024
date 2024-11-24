extends CharacterBody2D
class_name Bullet

func as_child_to(parent: Node) -> Bullet:
	parent.add_child(self)
	return self

func spawn(player_pos: Vector2, rot: float) -> void:
	var _direction: Vector2 = Vector2.DOWN.rotated(rot)
	velocity = _direction * 480.0
	position = player_pos + _direction * 25.0

func _physics_process(delta: float) -> void:
	position += velocity * delta
