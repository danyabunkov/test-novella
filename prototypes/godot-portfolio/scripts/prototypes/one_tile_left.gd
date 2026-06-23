extends "res://scripts/core/prototype_base.gd"

const LEVEL_PATH := "res://levels/one_tile_left/sample_levels.json"

var levels: Array = []
var level_index := 0
var level: Dictionary = {}
var selected_piece := -1
var placed: Dictionary = {}
var occupied: Dictionary = {}
var grid: GridContainer
var piece_row: HBoxContainer


func build() -> void:
	levels = _load_levels()
	add_note("Select a piece, then click an origin cell. Fill every non-target cell exactly once.")
	var nav := add_row()
	var previous := Button.new()
	previous.text = "Previous"
	previous.pressed.connect(_change_level.bind(-1))
	nav.add_child(previous)
	var next := Button.new()
	next.text = "Next"
	next.pressed.connect(_change_level.bind(1))
	nav.add_child(next)
	add_button("Reset level", _reset_level)
	piece_row = add_row()
	grid = GridContainer.new()
	root.add_child(grid)
	_load_level(0)


func _load_levels() -> Array:
	var file := FileAccess.open(LEVEL_PATH, FileAccess.READ)
	if file == null:
		return []
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_ARRAY:
		return []
	return parsed


func _load_level(index: int) -> void:
	if levels.is_empty():
		set_status("No levels found.")
		return
	level_index = posmod(index, levels.size())
	level = levels[level_index]
	selected_piece = -1
	placed.clear()
	occupied.clear()
	_rebuild_piece_buttons()
	_rebuild_grid()
	set_status("Level %d/%d: %s" % [level_index + 1, levels.size(), level.get("name", "Untitled")])


func _change_level(delta: int) -> void:
	_load_level(level_index + delta)


func _reset_level() -> void:
	_load_level(level_index)


func _rebuild_piece_buttons() -> void:
	for child in piece_row.get_children():
		child.queue_free()
	var pieces: Array = level.get("pieces", [])
	for index in range(pieces.size()):
		var piece: Dictionary = pieces[index]
		var button := Button.new()
		button.text = str(piece.get("id", "piece"))
		button.disabled = placed.has(index)
		button.pressed.connect(_select_piece.bind(index))
		piece_row.add_child(button)


func _select_piece(index: int) -> void:
	selected_piece = index
	set_status("Selected piece: %s" % level["pieces"][index].get("id", "piece"))


func _rebuild_grid() -> void:
	for child in grid.get_children():
		child.queue_free()
	var size := int(level.get("size", 4))
	grid.columns = size
	for y in range(size):
		for x in range(size):
			var button := Button.new()
			button.custom_minimum_size = Vector2(64, 64)
			button.text = _cell_text(Vector2i(x, y))
			button.pressed.connect(_try_place.bind(Vector2i(x, y)))
			grid.add_child(button)


func _cell_text(cell: Vector2i) -> String:
	var target := _target_cell()
	if cell == target:
		return "TARGET"
	for piece_index in occupied.get(cell, []):
		return str(level["pieces"][piece_index].get("id", "?"))
	return "."


func _try_place(origin: Vector2i) -> void:
	if selected_piece < 0:
		set_status("Select a piece first.")
		return
	if placed.has(selected_piece):
		set_status("That piece is already placed.")
		return
	var cells := _piece_cells(selected_piece, origin)
	if not _can_place(cells):
		set_status("Invalid placement.")
		return
	placed[selected_piece] = origin
	for cell in cells:
		occupied[cell] = [selected_piece]
	selected_piece = -1
	_rebuild_piece_buttons()
	_rebuild_grid()
	if _is_complete():
		set_status("Solved: every tile is covered except the target.")
	else:
		set_status("Piece placed. Continue.")


func _piece_cells(piece_index: int, origin: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var piece: Dictionary = level["pieces"][piece_index]
	for raw_cell in piece.get("cells", []):
		result.append(origin + Vector2i(int(raw_cell[0]), int(raw_cell[1])))
	return result


func _can_place(cells: Array[Vector2i]) -> bool:
	var size := int(level.get("size", 4))
	var target := _target_cell()
	for cell in cells:
		if cell.x < 0 or cell.y < 0 or cell.x >= size or cell.y >= size:
			return false
		if cell == target or occupied.has(cell):
			return false
	return true


func _is_complete() -> bool:
	var size := int(level.get("size", 4))
	var target := _target_cell()
	for y in range(size):
		for x in range(size):
			var cell := Vector2i(x, y)
			if cell == target:
				continue
			if not occupied.has(cell):
				return false
	return true


func _target_cell() -> Vector2i:
	var raw: Array = level.get("target", [0, 0])
	return Vector2i(int(raw[0]), int(raw[1]))
