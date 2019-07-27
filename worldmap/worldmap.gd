extends Node

signal send_location_info(location)

onready var agent = $agent
onready var cam = $cam
onready var pts = $points
onready var paths = $paths
onready var tw = $tween
onready var astar = AStar.new()

func _ready():
	# Move o agente para o último local salvo no estado do jogador
	agent.position = pts.get_node(player.world_location).rect_position
	cam.position = agent.position
	pts.get_node(player.world_location).grab_focus()
	# Cria as conexões no AStar
	for path in paths.get_children():
		var point = path.name.split("-")
		# Adiciona os pontos
		for p in point:
			var pt = pts.get_node(p)
			var pt_pos = Vector3(pt.rect_position.x, pt.rect_position.y, 0)
			# Cria o ponto e o torna interagível
			if not astar.has_point(pt.get_index()):
				astar.add_point(pt.get_index(), pt_pos)
				pt.connect("focus_entered", self, "_pt_focus_entered", [pt])
				pt.connect("pressed", self, "_pt_pressed", [pt])
		# Conecta os pontos
		astar.connect_points(pts.get_node(point[0]).get_index(), 
							 pts.get_node(point[1]).get_index())

func _pt_focus_entered(pt):
	if not tw.is_active():
		cam.position = pt.rect_position

func _pt_pressed(pt):
	# Verifica se o jogador clicou na mesma localidade
	if pt.name == player.world_location:
		emit_signal("send_location_info", pt)
		return
	# Desabilito os pontos de ser interagíveis
	_disable_moving()
	# Movemos o agente
	var start_id = pts.get_node(player.world_location).get_index()
	var end_id = pts.get_node(pt.name).get_index()
	var path = Array(astar.get_id_path(start_id, end_id))
	# Traçamos uma receita para sabermos o caminho traçado
	# pelo node 'paths', assim seguiremos essa rota
	var current = path.pop_front()
	while not path.empty():
		var p1 = pts.get_child(current).name
		var p2 = pts.get_child(path[0]).name
		var follow : PathFollow2D
		var start : int
		var end : int
		var duration = 1 # second
		# Indica por onde posso começar o caminho
		# 0 = inicio do PathFollow2D
		# 1 = final do PathFollow2D
		if paths.has_node("%s-%s" % [p1, p2]):
			follow = paths.get_node("%s-%s" % [p1, p2]).get_node('follow')
			start=0; end=1
		else:
			follow = paths.get_node("%s-%s" % [p2, p1]).get_node('follow')
			start=1; end=0
		# Como o follow no seu inicio
		# E o agente para seguir a interpolação de posição do follow
		follow.unit_offset = start
		tw.follow_property(agent, 'position', 
				follow.position, follow, 'position', 
				duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tw.follow_property(cam, 'position', 
				follow.position, follow, 'position', 
				duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tw.interpolate_property(follow, 'unit_offset', 
				start, end, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		# Inicio a interpolação e aguardo seu fim
		# E depois digo para seguir ao próximo ponto
		tw.start()
		yield(tw, "tween_all_completed")
		current = path.pop_front()
	# Mudamos o local no estado do jogador para o atual
	# E reativamos a entrada
	player.world_location = pt.name
	emit_signal("send_location_info", pt)
	_enable_moving()

func _disable_moving():
	pts.get_focus_owner().release_focus()
	for pt in pts.get_children():
		pt.disabled = true

func _enable_moving():
	pts.get_node(player.world_location).grab_focus()
	for pt in pts.get_children():
		pt.disabled = false