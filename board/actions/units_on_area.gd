extends BoardAction

export (Board.COLOR) var color
export (Unit.GROUP, FLAGS) var except_units = 0
export (Unit.GROUP, FLAGS) var only_units = 0

func begin():
	var units = []
	
	for unit in board.get_units_on_area(color):
		if unit.group&except_units and except_units:
			continue
		elif unit.group&only_units and only_units:
			units.append(unit)
		else:
			units.append(unit)
			
	event.units = units
	queue_free()
