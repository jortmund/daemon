extends Spatial
tool

signal camera_hover(event)
signal camera_pressed(event)

export var cell : Vector3 setget _set_cell
onready var board = get_parent()
onready var view : Camera = $view

func _set_cell(value):
	cell = value
	translation = cell * Board.CELL_SIZE

func _unhandled_key_input(event):
	# Evita algum erro durante a edição
	if Engine.editor_hint or $ui.get_focus_owner(): return
	
	var x = int(event.is_action_pressed("ui_up")) - int(event.is_action_pressed("ui_down"))
	var z = int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left"))
		
	if (x + z) and event.is_pressed():
		for y in [0] + range(-10, 10):
			var dir = cell + Vector3(x, y, z)
			if dir in board.get_used_cells() and not dir + Vector3.UP in board.get_used_cells():
				self.cell = dir
				emit_signal("camera_hover", {
					'cell': cell,
					'unit': board.get_unit_on_cell(cell),
					'areas': board.get_cell_areas(cell)
				})
				return
			
	if event.is_pressed():
		emit_signal("camera_pressed", {
			'cell': cell,
			'unit': board.get_unit_on_cell(cell),
			'areas': board.get_cell_areas(cell),
			'input': event
		})

func show():
	set_process_unhandled_key_input(true)
	visible = true

func hide():
	set_process_unhandled_key_input(false)
	visible = false