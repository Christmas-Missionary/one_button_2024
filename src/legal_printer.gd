extends Timer
## Prints all legal stuff. The setting `Export with Debug` MUST be enabled.

func _ready() -> void:
	const seperator: String = "\n----------------------------------------------------------\n"
	
	# init + Engine License
	var to_print: String = (
		"Here's to every license and copyright listed below:\n"
		+ "I am in no way endorsed by or related to any of these copyrights holders besides myself."
		+ seperator + Engine.get_license_text()
	)
	
	# For other licenses from assests I use
	var file: FileAccess = FileAccess.open("res://other_copyrights/this_project.txt", FileAccess.READ)
	to_print += seperator + file.get_as_text()
	file.close()
	
	# Copyrights to every Godot component
	var info: Array[Dictionary] = Engine.get_copyright_info()
	for entry: Dictionary in info:
		to_print += str(entry) + "\n\n"
	to_print += '\n'
	
	# Every 3rd party license used for Godot
	var license_title: Array = Engine.get_license_info().keys()
	var license_content: Array = Engine.get_license_info().values()
	for i in Engine.get_license_info().size():
		to_print += "\n/////\n\n" + str(license_title[i]) + "\n\n" + str(license_content[i])
		if i % 4 == 0:
			print(to_print)
			to_print = ""
			start()
			await timeout
	print("There's to every license and copyright listed above.\nDon't be scared, it's just legal stuff.")
