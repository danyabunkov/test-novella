extends "res://scripts/core/prototype_base.gd"

var lane := 1
var distance := 0
var obstacle_lane := 0
var running := true


func build() -> void:
	add_note("Switch lanes before the next obstacle. Reach 8 distance to catch the train.")
	var row := add_row()
	var left := Button.new()
	left.text = "Lane Left"
	left.pressed.connect(_move.bind(-1))
	row.add_child(left)
	var right := Button.new()
	right.text = "Lane Right"
	right.pressed.connect(_move.bind(1))
	row.add_child(right)
	add_button("Restart", _restart)
	_update_status()


func _move(delta: int) -> void:
	if not running:
		return
	lane = clampi(lane + delta, 0, 2)
	distance += 1
	obstacle_lane = (obstacle_lane + 2) % 3
	if lane == obstacle_lane:
		running = false
		set_status("Hit an obstacle at lane %d. Restart." % lane)
	elif distance >= 8:
		running = false
		set_status("You caught the last train.")
	else:
		_update_status()


func _restart() -> void:
	lane = 1
	distance = 0
	obstacle_lane = 0
	running = true
	_update_status()


func _update_status() -> void:
	set_status("Lane %d | Distance %d/8 | Next obstacle lane %d" % [lane, distance, obstacle_lane])
