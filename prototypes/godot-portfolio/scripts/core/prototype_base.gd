extends Control

var root: VBoxContainer
var status_label: Label
var data: Dictionary = {}


func configure(prototype_data: Dictionary) -> void:
	data = prototype_data
	_build_base()
	build()


func build() -> void:
	pass


func _build_base() -> void:
	root = VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 10)
	root.offset_left = 16
	root.offset_top = 16
	root.offset_right = -16
	root.offset_bottom = -16
	add_child(root)

	var title := Label.new()
	title.text = str(data.get("title", "Prototype"))
	title.add_theme_font_size_override("font_size", 28)
	root.add_child(title)

	var hook := Label.new()
	hook.text = str(data.get("hook", ""))
	hook.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(hook)

	status_label = Label.new()
	status_label.text = "Ready."
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(status_label)


func set_status(text: String) -> void:
	status_label.text = text


func add_note(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(label)
	return label


func add_button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	root.add_child(button)
	return button


func add_row() -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	root.add_child(row)
	return row
