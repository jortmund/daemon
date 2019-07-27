class_name Character
extends Unit
tool

export (String) var nick = ""
export (Texture) var CustomPortrait
export (int) var Level = 5 setget _set_level
var Experience = 0
var LvlUpExp = 0
var TotalExp = 0
export (Resource) var Wpn = Weapon.Load("dagger")
export (Resource) var Amr = Armor.Load("cloths")
export (int) var Str = 3
export (int) var Dex = 3
export (int) var Agi = 3
export (int) var Con = 3
export (int) var Vit = 3
export (int) var Int = 3
var Damage setget _set_damage
var MaxDamage setget _set_max_damage
var Defense setget _set_defense
var MaxDefense setget _set_max_defense
var MaxHealth setget _set_max_health
var Health = 0
var MaxSoul setget _set_max_soul
var Soul = 0
var MaxWeight setget _set_max_weight
var Weight setget _set_weight
var Balance setget _set_max_balance

func _set_level(value):
	Level = value
	_recalc_atts()

func _set_damage(value):
	_recalc_atts()

func _set_max_damage(value):
	_recalc_atts()

func _set_defense(value):
	_recalc_atts()

func _set_max_defense(value):
	_recalc_atts()

func _set_max_health(value):
	_recalc_atts()

func _set_health(value):
	_recalc_atts()
	Health = clamp(value, 0, MaxHealth) as int

func _set_max_soul(value):
	_recalc_atts()

func _set_soul(value):
	_recalc_atts()
	Soul = clamp(value, 0, MaxSoul) as  int

func _set_max_weight(value):
	_recalc_atts()

func _set_weight(value):
	_recalc_atts()

func _set_max_balance(value):
	_recalc_atts()

func _init():
	self.Level = Level

func _recalc_atts():
	MaxHealth = 20 + Con * 2 + Vit + ((Con * 10 + Vit * 5) / 10 * Level / 10) as int
	MaxSoul = 20 + Int * 2 + Vit + ((Int * 10 + Vit * 5) / 10 * Level / 10) as int
	MaxWeight = (10 + Str * 2 + Con) as int
	Weight = (Wpn.Weight + Amr.Weight) as float
	Balance = clamp(100 + MaxWeight - Weight * 2 - Wpn.Balance, 0, Wpn.MaxBalance) as int
	Damage = (Wpn.Min * (Wpn.Damage + get(Wpn.Attribute) + Level)) as int
	MaxDamage = (Wpn.Max * (Wpn.Damage + get(Wpn.Attribute) + Level)) as int
	Defense = (Amr.Min * (Amr.Defense + Con + Level)) as int
	MaxDefense = (Amr.Max * (Amr.Defense + Con + Level)) as int

# Compacta e descompacta o personagem
const _ATT_LIST = ["Name", "Level", "Wpn", "Amr",
		"Str", "Dex", "Agi", "Con", "Vit", "Int"]

func pack():
	var data = Dictionary()
	for att in _ATT_LIST:
		if get(att) is Resource:
			data[att] = get(att).resource_path
		else:
			data[att] = get(att)
	return data

func unpack(data):
	if not data.has_all(_ATT_LIST):
		print("Invalid data to parse.")
		return false
	for key in data:
		if get(key) is Resource:
			set(key, load(data[key]))
		else:
			set(key, data[key])
	return true
	
