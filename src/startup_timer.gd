extends Timer

func _ready() -> void:
	start(randf_range(2.5, 3.3))
	set_process_unhandled_key_input(false)

## Shows to the player which button to press
func _await_player() -> void:
	($"../Grid" as Sprite2D).hide()
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		var touch: = ($"../TouchButton" as TouchScreenButton)
		touch.show()
		touch.pressed.connect(_start, CONNECT_ONE_SHOT)
		($"../Arrows" as Node2D).show()
	else:
		($"../Keyboard" as AnimatedSprite2D).show()
		set_process_unhandled_key_input(true)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"OneButton"):
		set_process_unhandled_key_input(false) # One time thing
		_start()

## animation and audio will be done in 1.9 seconds.
## This function waits for 2.6 seconds total.
func _start() -> void:
	($"../Keyboard/Anime" as AnimationPlayer).play(&"FadeOut")
	($"../Audio" as AudioStreamPlayer).play()
	await get_tree().create_timer(2.6).timeout
	# CAUTION Because this preloads the next scene, that next scene or any preloads within MUST NOT refer to this scene.
	# When cyclic references are inevitable, PLEASE use load().
	get_tree().change_scene_to_packed(preload("res://src/main.tscn"))
