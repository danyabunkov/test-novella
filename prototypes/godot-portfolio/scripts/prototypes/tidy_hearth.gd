extends "res://scripts/core/prototype_base.gd"

var objects := {
	"mug": "shelf",
	"book": "table",
	"plant": "floor",
	"blanket": "floor",
}
var target := {
	"mug": "table",
	"book": "shelf",
	"plant": "window",
	"blanket": "sofa",
}
var spots := ["table", "shelf", "window", "sofa", "floor"]


func build() -> void:
	add_note("Click objects to cycle their location. Match the cozy target arrangement.")
	_render()


func _render() -> void:
	var row := add_row()
	for object_name in objects.keys():
		var button := Button.new()
		button.text = "%s -> %s" % [object_name, objects[object_name]]
		button.pressed.connect(_cycle.bind(object_name))
		row.add_child(button)
	_update_status()


func _cycle(object_name: String) -> void:
	var next_index := (spots.find(objects[object_name]) + 1) % spots.size()
	objects[object_name] = spots[next_index]
	for child in root.get_children():
		if child is HBoxContainer:
			child.queue_free()
	_render()


func _update_status() -> void:
	set_status("Room feels right." if objects == target else "The room is still slightly off.")
