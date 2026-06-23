extends Control

const PROTOTYPES: Array[Dictionary] = [
	{"id": "one_tile_left", "title": "One Tile Left", "hook": "Cover every tile except the last one.", "script": "res://scripts/prototypes/one_tile_left.gd"},
	{"id": "lumen", "title": "Lumen", "hook": "Rotate mirrors until light reaches the target.", "script": "res://scripts/prototypes/lumen.gd"},
	{"id": "tidy_hearth", "title": "Tidy Hearth", "hook": "Sort objects into a pleasing room order.", "script": "res://scripts/prototypes/tidy_hearth.gd"},
	{"id": "last_train_home", "title": "Last Train Home", "hook": "Switch lanes and catch the train.", "script": "res://scripts/prototypes/last_train_home.gd"},
	{"id": "glasshouse", "title": "Glasshouse", "hook": "Find hidden memories in the greenhouse.", "script": "res://scripts/prototypes/glasshouse.gd"},
	{"id": "postcards", "title": "Postcards from Nowhere", "hook": "Turn impossible postcards into a route.", "script": "res://scripts/prototypes/postcards.gd"},
	{"id": "lighthouse", "title": "The Lighthouse Keeper", "hook": "Choose who is allowed through the door.", "script": "res://scripts/prototypes/lighthouse.gd"},
	{"id": "signal", "title": "Signal", "hook": "Connect evidence before the broadcast fades.", "script": "res://scripts/prototypes/signal.gd"},
	{"id": "ink_tea", "title": "Ink & Tea", "hook": "Brew the right tea for the guest's mood.", "script": "res://scripts/prototypes/ink_tea.gd"},
	{"id": "hollow_year", "title": "The Hollow Year", "hook": "Carry memories across the repeating year.", "script": "res://scripts/prototypes/hollow_year.gd"},
]

var _content: PanelContainer
var _buttons: Array[Button] = []


func _ready() -> void:
	_build_layout()
	_open_prototype(0)


func _build_layout() -> void:
	var root := HBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 12)
	add_child(root)

	var sidebar := VBoxContainer.new()
	sidebar.custom_minimum_size = Vector2(260, 0)
	sidebar.add_theme_constant_override("separation", 6)
	root.add_child(sidebar)

	var title := Label.new()
	title.text = "Prototype Portfolio"
	title.add_theme_font_size_override("font_size", 22)
	sidebar.add_child(title)

	for index in range(PROTOTYPES.size()):
		var data: Dictionary = PROTOTYPES[index]
		var button := Button.new()
		button.text = "%02d  %s" % [index + 1, data["title"]]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(_open_prototype.bind(index))
		sidebar.add_child(button)
		_buttons.append(button)

	_content = PanelContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(_content)


func _open_prototype(index: int) -> void:
	for button_index in range(_buttons.size()):
		_buttons[button_index].disabled = button_index == index

	for child in _content.get_children():
		child.queue_free()

	var data: Dictionary = PROTOTYPES[index]
	var script: Script = load(data["script"])
	var view: Control = script.new()
	view.set_anchors_preset(Control.PRESET_FULL_RECT)
	if view.has_method("configure"):
		view.configure(data)
	_content.add_child(view)
