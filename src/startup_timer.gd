extends Timer

func _ready() -> void:
	start(randf_range(0.8, 2.2))
	set_process_unhandled_key_input(false)

func _await_player() -> void:
	($"../Grid" as Sprite2D).hide()
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		var touch: = ($"../TouchButton" as TouchScreenButton)
		touch.show()
		touch.pressed.connect(_start, CONNECT_ONE_SHOT)
	else:
		($"../Keyboard" as AnimatedSprite2D).show()
		set_process_unhandled_key_input(true)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"OneButton"):
		set_process_unhandled_key_input(false)
		_start()

func _start() -> void:
	($"../Keyboard/Anime" as AnimationPlayer).play(&"FadeOut")
	($"../Audio" as AudioStreamPlayer).play()
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_packed(preload("res://src/main.tscn"))
