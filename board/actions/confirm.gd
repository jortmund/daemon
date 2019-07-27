extends BoardAction

func begin():
	var menu = PopupMenu.new()
	add_child(menu)
	menu.add_item("Yes", 1)
	menu.add_item("No", 0)
	menu.popup_centered(Vector2(50,50))
	if not yield(menu, "id_pressed"):
		emit_signal("failure")
	queue_free()
