extends "res://scripts/core/prototype_base.gd"

var links := {}
var evidence := ["frequency 73.1", "tape hiss", "missing operator"]


func build() -> void:
	add_note("Connect evidence to the right explanation before paranoia wins.")
	var row := add_row()
	for item in evidence:
		var button := Button.new()
		button.text = "Link %s" % item
		button.pressed.connect(_link.bind(item))
		row.add_child(button)
	_update_status()


func _link(item: String) -> void:
	links[item] = true
	_update_status()


func _update_status() -> void:
	if links.size() == evidence.size():
		set_status("Deduction complete: the broadcast is a recorded warning from tomorrow.")
	else:
		set_status("Evidence linked %d/%d. Static rising." % [links.size(), evidence.size()])
