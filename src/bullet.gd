extends CharacterBody2D
class_name Bullet

@onready var _bounce: = $Bounce as AudioStreamPlayer

## Used to pipeline spawning of a bullet
func as_child_to(parent: Node) -> Bullet:
	parent.add_child(self)
	return self

## This is always called after the node is in scene tree
func spawn(player_pos: Vector2, rot: float) -> void:
	var _direction: Vector2 = Vector2.DOWN.rotated(rot)
	velocity = _direction * 480.0 # 480.0 is speed
	position = player_pos + _direction * 10.0

func _physics_process(_delta) -> void:
	move_and_slide()
	if !is_on_wall():
		return
	_bounce.play()
	match (get_wall_normal()):
		Vector2.UP, Vector2.DOWN:
			velocity.y = -velocity.y
		Vector2.LEFT, Vector2.RIGHT:
			velocity.x = -velocity.x
		_:
			const RAND_ROT: float = TAU / 12.0
			velocity = (-velocity).rotated(randf_range(-RAND_ROT, RAND_ROT)) # Adds variation
