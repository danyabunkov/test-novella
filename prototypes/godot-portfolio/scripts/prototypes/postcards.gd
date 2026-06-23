extends "res://scripts/core/prototype_base.gd"

var chapter := 0
var trust_sender := 0
var cards := ["The city floating at dusk", "The station with no trains", "The lighthouse in the desert"]


func build() -> void:
	add_note("Advance through postcards. Your replies steer the final tone.")
	var row := add_row()
	var believe := Button.new()
	believe.text = "Believe the sender"
	believe.pressed.connect(_reply.bind(1))
	row.add_child(believe)
	var doubt := Button.new()
	doubt.text = "Doubt the sender"
	doubt.pressed.connect(_reply.bind(-1))
	row.add_child(doubt)
	_update_status()


func _reply(delta: int) -> void:
	trust_sender += delta
	chapter += 1
	_update_status()


func _update_status() -> void:
	if chapter >= cards.size():
		set_status("Ending: %s" % ("Follow the map that appears." if trust_sender > 0 else "Burn the final postcard."))
	else:
		set_status("Postcard %d/%d: %s" % [chapter + 1, cards.size(), cards[chapter]])
