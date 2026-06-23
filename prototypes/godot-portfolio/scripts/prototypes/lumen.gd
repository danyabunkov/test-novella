extends "res://scripts/core/prototype_base.gd"

var mirrors := [false, true, false]


func build() -> void:
	add_note("Toggle mirrors. The beam reaches the crystal when the pattern is ON, OFF, ON.")
	_render()


func _render() -> void:
	var row := add_row()
	for index in range(mirrors.size()):
		var button := Button.new()
		button.text = "Mirror %d: %s" % [index + 1, "ON" if mirrors[index] else "OFF"]
		button.pressed.connect(_toggle.bind(index))
		row.add_child(button)
	_update_status()


func _toggle(index: int) -> void:
	mirrors[index] = not mirrors[index]
	for child in root.get_children():
		if child is HBoxContainer:
			child.queue_free()
	_render()


func _update_status() -> void:
	if mirrors == [true, false, true]:
		set_status("Solved: the cyan beam reaches the target.")
	else:
		set_status("Beam path is blocked.")
