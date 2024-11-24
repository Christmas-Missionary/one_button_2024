extends CharacterBody2D
class_name Bullet

const GROUP_NAME: StringName = &"Bullets"

static var num_of_bullets: int = 0

func as_child_to(parent: Node) -> Bullet:
	parent.add_child(self)
	return self

func spawn(player_pos: Vector2, rot: float) -> void:
	num_of_bullets += 1
	add_to_group(GROUP_NAME)
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

func _exit_tree() -> void:
	num_of_bullets -= 1
