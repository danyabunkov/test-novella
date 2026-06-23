extends "res://scripts/core/prototype_base.gd"

var targets := ["rusty key", "orchid tag", "cracked lens"]
var found: Array[String] = []


func build() -> void:
	add_note("Find all listed greenhouse objects.")
	var row := add_row()
	for item in ["watering can", "rusty key", "fern", "orchid tag", "cracked lens", "moss"]:
		var button := Button.new()
		button.text = item
		button.pressed.connect(_inspect.bind(item))
		row.add_child(button)
	_update_status()


func _inspect(item: String) -> void:
	if targets.has(item) and not found.has(item):
		found.append(item)
	_update_status()


func _update_status() -> void:
	if found.size() == targets.size():
		set_status("Scene complete. Diary fragment unlocked: 'The glass cracked after the final winter.'")
	else:
		set_status("Found %d/%d: %s" % [found.size(), targets.size(), ", ".join(found)])
