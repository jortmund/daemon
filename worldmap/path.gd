extends Path2D

func _draw():
	visible = true
	curve.bake_interval = 12
	self_modulate = Color.white
	for point in curve.get_baked_points():
		draw_circle(point, 2.5, Color.white)
	