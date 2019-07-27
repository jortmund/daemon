extends Node
class_name BoardEvent

signal completed(data)
signal failure

onready var board = get_tree().get_meta("board")

var data = {}

func begin():
	for action in get_children():
		if action.has_method("begin") and action.is_in_group("board_action"):
			action.connect("failure", self, "_cancel")
			action.begin()
			yield(action, "tree_exiting")
		else: 
			action.queue_free()
	data.completed = true
	queue_free()

func _cancel():
	data.completed = false
	queue_free()

func _exit_tree():
	board.clear_areas()
	emit_signal("completed", data)
	print(data)
