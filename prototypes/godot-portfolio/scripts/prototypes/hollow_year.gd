extends "res://scripts/core/prototype_base.gd"

var loop := 1
var clues: Array[String] = []
var available := ["the well remembers", "the church bell is late", "the girl never ages"]


func build() -> void:
	add_note("Repeat the year, keep memories, and break the loop.")
	var row := add_row()
	var investigate := Button.new()
	investigate.text = "Investigate today"
	investigate.pressed.connect(_investigate)
	row.add_child(investigate)
	var sleep := Button.new()
	sleep.text = "Let the year reset"
	sleep.pressed.connect(_reset_year)
	row.add_child(sleep)
	_update_status()


func _investigate() -> void:
	if clues.size() < available.size():
		clues.append(available[clues.size()])
	_update_status()


func _reset_year() -> void:
	loop += 1
	_update_status()


func _update_status() -> void:
	if clues.size() == available.size():
		set_status("Escape ending: memory survives the hollow year on loop %d." % loop)
	else:
		set_status("Loop %d | Remembered clues %d/%d: %s" % [loop, clues.size(), available.size(), ", ".join(clues)])
