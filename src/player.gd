extends Area2D

@onready var _shoot: = $Shoot as AudioStreamPlayer
@onready var _death: = $Death as AudioStreamPlayer
@onready var _bullet_pool: Node = $/root/Main/BulletPool
@onready var _cooldown: = $Cooldown as Timer

func _physics_process(delta: float) -> void:
	const _ROT_SPEED: float = PI / 1.2
	rotate(_ROT_SPEED * delta)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"OneButton") and _bullet_pool.get_child_count() < 5 and is_visible() and !_cooldown.time_left:
		((preload("res://src/bullet.tscn")
		.instantiate() as Bullet)
		.as_child_to(_bullet_pool)
		.spawn(position, rotation))
		_shoot.play()
		_cooldown.start()
		set_process(true)

const _RESET_TIME: float = 5.0
var time_left_to_reset: float = _RESET_TIME
func _process(delta: float) -> void:
	if Input.is_action_pressed(&"OneButton"):
		time_left_to_reset -= delta
		if time_left_to_reset <= 0.0:
			($"../Maze" as Maze).wipe_save()
			get_tree().change_scene_to_file("res://src/starting_up.tscn")
	else:
		time_left_to_reset = _RESET_TIME
		set_process(false)

func check_for_bullet(body: Node2D) -> void:
	if body is Bullet:
		for bullet: Node in _bullet_pool.get_children():
			bullet.queue_free()
		hide()
		_death.play()
