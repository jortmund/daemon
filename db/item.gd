extends Resource
class_name Item

# Empty
const None = 0
# Weapons
const Dagger = 1
const Sword = 2
const Lance = 4
const Staff = 8
const Book = 16
const Bow = 32
# Armors
const Cloth = 64
const Leather = 128
const Metal = 256
# Etc
const Healing = 512
const Ammo = 1024
# Categorys
const Weapon = Dagger+Sword+Lance+Staff+Book+Bow
const Armor = Cloth+Leather+Metal
const Etc = Healing+Ammo

enum Types {
	None=None
	Dagger=Dagger Sword=Sword Lance=Lance 
	Staff=Staff Book=Book Bow=Bow
	Cloth=Cloth Leather=Leather Metal=Metal
	Healing=Healing Ammo=Ammo
}

enum Categorys {
	Weapon=Weapon Armor=Armor Etc=Etc
}

export (String) var Name
export (int, -1, 15) var Level
export (Types) var Type : int
