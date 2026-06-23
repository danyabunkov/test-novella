extends "res://scripts/core/prototype_base.gd"

var day := 1
var friendship := 0
var guest_mood := "tired"
var correct := {"tired": "black tea", "anxious": "mint", "nostalgic": "oolong"}


func build() -> void:
	add_note("Choose tea to match the guest's mood.")
	var row := add_row()
	for tea in ["black tea", "mint", "oolong"]:
		var button := Button.new()
		button.text = tea
		button.pressed.connect(_serve.bind(tea))
		row.add_child(button)
	_update_status()


func _serve(tea: String) -> void:
	if correct[guest_mood] == tea:
		friendship += 1
	day += 1
	var moods := correct.keys()
	guest_mood = moods[(day - 1) % moods.size()]
	_update_status()


func _update_status() -> void:
	if friendship >= 3:
		set_status("Arc unlocked: the regular leaves a handwritten story.")
	else:
		set_status("Day %d | Guest mood: %s | Friendship: %d/3" % [day, guest_mood, friendship])
