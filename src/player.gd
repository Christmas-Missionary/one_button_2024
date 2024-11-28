extends Area2D

@onready var _shoot_audio: = $Shoot as AudioStreamPlayer
@onready var _cooldown: = $Cooldown as Timer
@onready var _bullet_pool: Node = $/root/Main/BulletPool
@onready var _particles_pool: Node = $/root/Main/ParticlesPool

signal player_dead

func _physics_process(delta: float) -> void:
	const _ROT_SPEED: float = PI / 1.2
	rotate(_ROT_SPEED * delta)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"OneButton"):
		_shoot()

func _shoot() -> void:
	if _bullet_pool.get_child_count() < 5 and is_visible() and !_cooldown.time_left:
		((preload("res://src/bullet.tscn")
		.instantiate() as Bullet)
		.as_child_to(_bullet_pool)
		.spawn(position, rotation))
		_shoot_audio.play()
		_cooldown.start()
		set_process(true)

const _RESET_TIME: float = 5.0
var time_left_to_reset: float = _RESET_TIME
func _process(delta: float) -> void:
	if Input.is_action_pressed(&"OneButton"):
		time_left_to_reset -= delta
		if time_left_to_reset <= 0.0:
			reset_everything()
	else:
		time_left_to_reset = _RESET_TIME
		set_process(false)

func reset_everything() -> void:
	($"../Maze" as Maze).wipe_save()
	get_tree().change_scene_to_file("res://src/starting_up.tscn")

# todo: make into player_dead signal
func check_for_bullet(body: Node2D) -> void:
	if body is Bullet:
		((preload("res://src/player_exploding.tscn")
		.instantiate() as PlayerParticles)
		.as_child_to(_particles_pool)
		.spawn(transform))
		player_dead.emit()
