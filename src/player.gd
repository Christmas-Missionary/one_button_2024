extends Area2D

@onready var _shoot: = $Shoot as AudioStreamPlayer
@onready var _death: = $Death as AudioStreamPlayer
@onready var _bullet_pool: Node = $/root/Main/BulletPool

func _physics_process(delta: float) -> void:
	const _ROT_SPEED: float = PI / 1.2
	rotate(_ROT_SPEED * delta)

func _unhandled_key_input(event: InputEvent) -> void:
	const _BULLET_SCENE: PackedScene = preload("res://src/bullet.tscn")
	if event.is_action_pressed(&"OneButton") and Bullet.num_of_bullets < 5 and is_visible():
		(_BULLET_SCENE.instantiate() as Bullet).as_child_to(_bullet_pool).spawn(position, rotation)
		_shoot.play()

func check_for_bullet(body: Node2D) -> void:
	if body is Bullet:
		get_tree().call_group(Bullet.GROUP_NAME, queue_free.get_method())
		hide()
		_death.play()
