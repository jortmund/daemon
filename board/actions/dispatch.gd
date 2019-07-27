extends BoardAction
tool

# Leave empty for a random character
export var unit : PackedScene setget _set_unit

# Only units
func _set_unit(value):
	if not Engine.editor_hint:
		unit = value
	else:
		unit = null
		if value:
			if value.can_instance():
				var v = value.instance()
				if v is Unit:
					unit = value

# Esse evento adiciona a unidade ao tabuleiro
func begin():
	if not unit:
		print("Unit to dispatch is empty.")
	elif unit.can_instance():
		get_tree().get_meta("board").add_child(unit.instance())
		print("Dispaching %s." % unit.get_name())
	else:
		print("Failed to dispatch %s." % unit.get_name())
	queue_free()
