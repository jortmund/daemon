extends Item
class_name Armor

export (float, 0, 99) var Defense = 0
export (float, 0, 2) var Min = 0
export (float, 0, 2) var Max = 0
export (float, 0, 99) var Weight = 0
export (int, -100, 110) var Balance = 0

static func Load(amr):
	var dir : Directory = Directory.new()
	
	if dir.file_exists("res://db/armor/%s.tres" % amr):
		return load("res://db/armor/%s.tres" % amr)
	
	print("Armor cannot be loaded due a prob.")
