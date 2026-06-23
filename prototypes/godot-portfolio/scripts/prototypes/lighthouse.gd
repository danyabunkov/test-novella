extends "res://scripts/core/prototype_base.gd"

var guests := ["old sailor", "lost child", "sea-wet stranger"]
var guest_index := 0
var mercy := 0
var danger := 0


func build() -> void:
	add_note("Each night a guest arrives. Admit or deny them.")
	var row := add_row()
	var admit := Button.new()
	admit.text = "Admit"
	admit.pressed.connect(_choose.bind(true))
	row.add_child(admit)
	var deny := Button.new()
	deny.text = "Deny"
	deny.pressed.connect(_choose.bind(false))
	row.add_child(deny)
	_update_status()


func _choose(admit: bool) -> void:
	if admit:
		mercy += 1
		if guest_index == 2:
			danger += 1
	else:
		danger += 1
	guest_index += 1
	_update_status()


func _update_status() -> void:
	if guest_index >= guests.size():
		set_status("Ending: %s" % ("The light stays warm." if mercy > danger else "The sea takes the house."))
	else:
		set_status("Night %d: %s knocks at the door." % [guest_index + 1, guests[guest_index]])
