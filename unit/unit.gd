extends Spatial
class_name Unit
tool

enum FACE { FORWARD=1 BACK=2 RIGHT=4 LEFT=8 }
enum GROUP { PLAYER=1 ENEMY=2 GUEST=4 ENV=8 }
# Posição dessa entidade no Tabuleiro
export var cell : Vector3 setget _set_cell
export (FACE) var facing = 1 setget _update_facing
export (GROUP) var group = 1

onready var anim = $anim
onready var mesh = $mesh
onready var area = $area setget ,_get_area

func _set_cell(new_cell):
	if new_cell == null: return
	cell = new_cell
	translation = cell * Vector3(2,1,2)

func _get_area():
	if not area: return
	var list : PoolVector3Array
	for area_cell in area.get_used_cells() as PoolVector3Array:
		list.append(cell + area_cell)
	return list

var _front_face : PoolVector3Array
func _update_facing(face):
	facing = face
	if not area or not area and Engine.editor_hint:
		return
	if not _front_face: _front_face = area.get_used_cells()
	area.clear()
	match(facing):
		FACE.FORWARD:
			for v in _front_face:
				area.set_cell_item(v.x, v.y, v.z, 0)
		FACE.BACK:
			for v in _front_face:
				area.set_cell_item(-v.x, v.y, -v.z, 0)
		FACE.RIGHT:
			for v in _front_face:
				area.set_cell_item(-v.z, v.y, v.x, 0)
		FACE.LEFT:
			for v in _front_face:
				area.set_cell_item(v.z, v.y, v.x, 0)
