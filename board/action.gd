extends Node
class_name BoardAction

signal failure

onready var board = get_tree().get_meta("board") if is_inside_tree() and not Engine.editor_hint else null
onready var event = get_parent().data as Dictionary

func begin():
	print("Starting empy event...")
	queue_free()

func _enter_tree():
	if not get_parent().is_in_group("board_event") and not Engine.editor_hint:
		queue_free()
