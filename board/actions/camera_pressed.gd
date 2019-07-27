extends BoardAction

export (Board.COLOR) var color := 0

var running = true

func begin():
	var pressed = yield(board.camera, "camera_pressed")
	while running:
		if color in pressed.areas and pressed.input.is_action_pressed('ui_accept'):
			event.cell = pressed.cell
			event.unit = pressed.unit
			event.areas = pressed.areas
			queue_free()
			running = false
		else:
			pressed = yield(board.camera, "camera_pressed")
	