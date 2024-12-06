extends TouchScreenButton
class_name Touch

static var is_mobile_on_web: bool = false

func _ready() -> void:
	# This if-statement was a lifesaver
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		is_mobile_on_web = true
		show()
