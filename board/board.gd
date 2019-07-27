extends GridMap
class_name Board

const CELL_SIZE = Vector3(2,1,2)

export var link_default_width := 0
export var link_default_height := 10
export var link_default_search_height := 10
export var link_default_parent_length := 2

onready var camera : Camera = $camera
onready var events : Node = $events
onready var _area : GridMap = $area
onready var _nav : GridMap = $nav


enum FILTER { CIRCLE=1 SQUARE LINE }
enum COLOR { WHITE=0 RED GREEN BLUE YELLOW }
var area = {} # segura a cores das areas com suas células

# Ao entrar no mapa se torna o tabuleiro principal
func _enter_tree():
	# Apaga o mapa antigo
	if get_tree().has_meta("board"):
		get_tree().get_meta("board").queue_free()
	# Torna este o mapa principal
	get_tree().set_meta("board", self)
	name = "board"

func _ready():
	request_events()

func request_events():
	for event in get_tree().get_nodes_in_group("board_event"):
		if event.has_method("begin"):
			event.begin()
			yield(event, "completed")
		else: 
			event.queue_free()

func get_unit_on_cell(cell):
	for unit in get_tree().get_nodes_in_group("unit"):
		if cell in unit.area: return unit

func get_units_on_area(color):
	var units = []
	if color in area:
		for unit in get_tree().get_nodes_in_group("unit"):
			for cell in unit.area:
				if cell in area[color]:
					units.append(unit)
	return units

func get_units_cells(groups:=PoolIntArray(), only_host_cell:=true):
	var units_cells : PoolVector3Array
	for unit in get_tree().get_nodes_in_group("unit"):
		if unit.cell in _nav.get_used_cells():
			if groups: 
				for group in groups:
					if group == unit.group:
						if only_host_cell:
							units_cells.append(unit.cell)
						else:
							units_cells.append_array(unit.area)
					break
				continue
			if only_host_cell:
				units_cells.append(unit.cell)
			else:
				units_cells.append_array(unit.area)
	return units_cells

func get_cells(expt=[]):
	var expt_cells = get_units_cells(expt)
	var empty_cells : PoolVector3Array
	for cell in _nav.get_used_cells():
		if expt and cell in expt_cells:
			continue
		empty_cells.append(cell)
	return empty_cells

func get_cell_areas(cell):
	var areas := PoolIntArray()
	for color in area:
		if cell in area[color]:
			areas.append(color)
	return areas

func filter_by_radius(cells:PoolVector3Array, origin:Vector3, 
					  width:int, height:int, 
					  filter:int, facing:=int()):
	# Nulo se a origem não estiver na area
	if not origin in cells: return PoolVector3Array()
	
	var filtered : PoolVector3Array
	match(filter):
		FILTER.CIRCLE:
			for cell in cells:
				var x = abs(origin.x - cell.x)
				var z = abs(origin.z - cell.z)
				var y = abs(origin.y - cell.y)
				if width > (x + z) and height > y: filtered.append(cell)
		FILTER.SQUARE:
			for x in range(-width, width + 1):
				for z in range(-width, width + 1):
					for y in range(-height, height + 1):
						var cell = Vector3(x,y,z) + origin
						if cell in cells: filtered.append(cell)
	return filtered

func create_link(cells, origin, width=link_default_width, height=link_default_height):
	if not cells: return Dictionary()
	
	var links = Dictionary()
	var costs = Dictionary()
	var avaliable = Array()
	
	links[origin] = null
	costs[origin] = 0
	avaliable.append(origin)
	
	while not avaliable.empty():
		var cell = avaliable.pop_front()
		for parent in filter_by_radius(cells, cell, 
				link_default_parent_length, 
				link_default_search_height, FILTER.CIRCLE):
			if not parent in links and parent in cells:
				var ok = true
				# Custo
				if width:
					costs[parent] = costs[cell] + 1
					if costs[parent] >= width:
						break
				# Chão
				if cell.y > parent.y:
					for y in abs(cell.y - parent.y) + 1:
						var ground = parent; ground.y += y
						if ground in get_cells() and y or height < y:
							ok = false; break
				# Teto
				elif cell.y < parent.y:
					for y in abs(cell.y - parent.y) + 1:
						var ceiling = cell; ceiling.y += y
						if ceiling in get_cells() and y or height < y:
							ok = false; break
				if ok:
					links[parent] = cell
					avaliable.append(parent)
	return links

func get_link_path(link, cell):
	if not cell in link: return PoolVector3Array()
	
	var path = PoolVector3Array()
	var processing = cell
	
	while processing != null:
		path.append(processing)
		processing = link[processing]
	return path

func clear_areas():
	area.clear()
	_area.clear()

func draw_areas():
	_area.clear()
	for color in COLOR.values():
		if color in area:
			for v in area[color]:
				_area.set_cell_item(v.x, v.y, v.z, color)
