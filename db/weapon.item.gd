extends Item
class_name Weapon

export (int, 0, 999) var Damage = "1"
export (float, 0, 2, 0.1) var Min = 1
export (float, 0, 2, 0.1) var Max = 1
export (Vector2) var Distance : Vector2
export (float, 0, 99) var Weight = 0
export (int, -100, 110) var Balance = 0
export (int, -100, 110) var MaxBalance = 0
export (String, "Str", "Int", "Dex") var Attribute = "Str"

static func Load(name):
	var dir : Directory = Directory.new()
	
	if dir.file_exists("res://db/weapons/%s.tres" % name):
		return load("res://db/weapons/%s.tres" % name)
	
	print("Armor cannot be loaded due a prob.")
