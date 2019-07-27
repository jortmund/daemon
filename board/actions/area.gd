extends BoardAction

export (Board.COLOR) var color := 0
export var origin := Vector3()
export var width := int()
export var height := int()
export (Board.FILTER) var filter := 1
export (Unit.FACE) var facing

func begin():
	board.area.clear()
	board.area[color] = board.filter_by_radius(
			board.get_cells(),
			event.get('cell', origin), 
			width, height, filter, facing)
	board.draw_areas()
	queue_free()
