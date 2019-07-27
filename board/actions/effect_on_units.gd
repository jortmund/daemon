extends BoardAction

export var effect : PackedScene

func begin():
	board.camera.hide()
	for unit in event.get('units', Array()):
		var eff = effect.instance()
		eff.translation = unit.translation
		eff.translation.y += 2
		add_child(eff)
		print("Casting %s on %s" % [eff.name, unit.nick])
		yield(eff, "tree_exited")
	board.camera.show()
	queue_free()
